---
title: Implementing Moves
subtitle: Quick start guide to RevBayes development by adding a new move
category: implementation
---

# Implementing a Metropolis-Hastings Move
{:.section}

## General info before getting started
{:.subsection}

The steps to implementing a new move vary slightly, depending on the move's type (e.g., Metropolis-Hastings versus Gibbs). For the purposes of this guide, we will focus on a Metropolis-Hastings move.

In general, the fastest and easiest way to get help is to find the most similar move already implemented in RevBayes and use it as a guide. Remember that, as with implementing a new distribution or function, you'll need to add relevant code to both the core of RevBayes and the language. Also remember that you'll need to work out the math appropriate for your move (e.g., the Hastings ratio) ahead of time.

## Steps
{:.subsection}

1.  _Orienting within the repository_ - For the **core**, navigate in the repository to `src/core/moves`. For a Metropolis-Hastings move, we'll then go into the `proposal` directory. In this directory, you can find several templates for generic proposal classes, as well as subdirectories containing moves for specific parameter types. To keep things easy, we'll focus on a single scalar parameter, so we'll navigate one step further into the `scalar` directory. For the **language**, navigate to `src/revlanguage/moves`. For this example, as we did in the core, we'll focus on a move for a scalar parameter, so we'll then open `scalar`. To **register** our new move after it's implemented, we'll also need to update the file `src/revlanguage/workspace/RbRegister_Move.cpp`.

2.  _Creating new files for the core_ - As an example, we'll implement a new move that draws a random value from a Gamma distribution and proposes a new scalar by multiplying the current value by the draw from the Gamma. This move will be called a "Gamma Scaling move". Since this move is similar to an existing scaling move, we can start by copying the file `ScaleProposal.h` and naming the new copy `GammaScaleProposal.h`. As a reminder, we're working in the directory `src/core/moves/proposal/scalar/`. 

    Once the new **header file** is created and named, we can update the content to match our new move. The simplest changes involve renaming things to match the new move (e.g., updating the preprocessor macro from `ScaleProposal_H` to `GammaScaleProposal_H`, or changing the name of object references and constructor from `ScaleProposal` to `GammaScaleProposal`). The comments at the top of the header file that describe how the move works should also be updated, but these changes will obviously be specific to the move being implemented.

    Next, we'll need to create a **new .cpp file** containing the implementation of our new move. As with the header, it's easiest to copy and rename an existing file, so we'll use `ScaleProposal.cpp` as our template, copy it, and rename to `GammaScaleProposal.cpp`. As with the header file, most of the necessary changes involve updating the names of variables and function names. If the move requires access to other math functions, additional header files may need to be included at the top. Explore `src/core/math` as needed to find the necessary functions or distributions. For our example, the number and type of variables used by our move is the same as our template, so we don't need to modify the constructor or variable initialization, other than updating the constructor name. Similarly for this example, we don't need to alter the code in the `::cleanProposal`, `::clone`, `::prepareProposal`, `::printParameterSummary`, `::undoProposal`, `::swapNodeInternal`, and `::tune` methods as these are common to our template and new moves (and will be identical to many of the scalar moves), but we do need to update the class names associated with the methods (i.e., `ScaleMove::` -> `GammaScaleMove::`). For the `::getProposalName` method, we need to update the string in the method that provides a descriptive name for the move - `name = "Gamma Scaling"`. The bulk of the necessary changes for the new move will come in the `::propose` method and the help description above the method. For this example, the new `::propose` method looks like this:

    ```cpp
/*
 * Perform the proposal.
 *
 * A gamma scaling proposal draws a random number from a gamma distribution u ~ Gamma(lambda,1) and scales the current vale by u
 * lambda is the tuning parameter of the proposal which influences the size of the proposals by changing the shape of the Gamma.
 *
 * \return The hastings ratio.
 */
double GammaScaleProposal::propose( double &val )
{
    
    // Get random number generator
    RandomNumberGenerator* rng     = GLOBAL_RNG;
    
    // copy value
    storedValue = val;
    
    // Generate new value (no reflection, so we simply abort later if we propose value here outside of support)
    double u = RbStatistics::Gamma::rv(lambda,1,*rng);
    val *= u;
    
    // compute the Hastings ratio
    double ln_hastings_ratio = 0;
    try
    {
        // compute the Hastings ratio
        double forward = RbStatistics::Gamma::lnPdf(lambda, 1, u);
        double backward = RbStatistics::Gamma::lnPdf(lambda, 1, (1.0/u));
        
        ln_hastings_ratio = backward - forward - log(u);    // The -log(u) term is the Jacobian
    }
    catch (RbException e)
    {
        ln_hastings_ratio = RbConstants::Double::neginf;
    }

    return ln_hastings_ratio;
}
```

In this case, the Hastings ratio involves the probability density of the forward move (the scaling factor *u*), the corresponding backward move (the scaling factor $\frac{1}/{u}$), and the solution to the Jacobian ($-\frac{1}{u}$).

3.  _Creating new files for the rev language_ -


4.  _Testing the performance of the new move_ - If properly implemented, a new move can be validated by running an MCMC analysis where the data are ignored and one tries to sample only the prior. This can be done in RevBayes by adding the `underPrior=TRUE` option as an argument to the `.run()` method of an `mcmc` object. The recommended strategy is to implement the simplest possible model that uses a variable of the type appropriate for the new move, and assigning that variable an easily validated prior (e.g., a uniform). Run the analysis with only the new move operating on that variable and then plot the variable's marginal distribution to make sure it matches the prior.