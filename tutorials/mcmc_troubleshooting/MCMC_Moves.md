{% assign moves_script = "moves.Rev" %}

{% section Moves/Operators %}

In order for the MCMC to work properly, every parameter that is supposed to be optimized (i.e., for which we are searching for the best estimate) has to be associated with a move or operator.
The type of move and its settings determine how the parameter can be changed between MCMC steps, how much it can be changed by, and how often a change is attempted.
If the move(s) for a parameter is missing, that parameter cannot be optimized, which will usually cause issues for the MCMC.
To set up the code in a way to avoid missing operators is to specify them right after the priors for a parameter is set:
{{ moves_script | snippet: "block#", "1" }}

All move functions in RevBayes start with the prefix `mv`.
The exact arguments differ from move to move, but generally it includes three things:
The name of the parameter the move should act on (`x` in the example of the sliding move), one or more arguments needed as settings for the move algorithm (e.g., the sliding window's size parameter `delta`), and the move's weight, which determines how often this move will be attempted on average during each MCMC step.
{{ moves_script | snippet: "block#", "2" }}
On top of these, moves can have the arguments `tune` (and `tuneTarget`).
The former is a boolean (i.e., `TRUE`/`FALSE`) which defines whether the setting-parameters of the move (e.g., window size `delta` here) is allowed to be optimized during auto-tuning.
We will revisit the tuning options further below.

The whole set of moves in an analysis are collected in a moves vector (which can be defined upfront and be added to using `.append()`), so we can look at this vector before running to ensure it contains all the moves we want.
{{ moves_script | snippet: "block#", "3" }}


{% subsection Weights %}

As mentioned, the weight of a move determines how often that move is attempted, meaning that parameters with higher weights are updated more often, which can be helpful for parameters that are harder to optimize or for which a larger parameter space needs to be covered to find the optima.
For simpler parameters, lower weights are sufficient, to not make the MCMC inefficient by enforcing unnecessary move-attempts.
Note that in RevBayes, where multiple moves can be performed between each iteration of the chain, the weight implies the average number of move attempts per iteration.
In other implementations (e.g., MrBayes, BEAST2), where only one parameter changes per iteration, the weights imply the probabilty for this parameter to be chosen.

Reconsidering weights may be a good idea if some parameters struggle more to converge than others (as can be gleaned from the ESS and traces).
The weights of slower converging parameters can be increased to speed up the search for more optimal values, and those of more easily converging parameters may even be reduced to not slow down the overall convergence speed of the analysis.
{{ moves_script | snippet: "block#", "4" }}


{% subsection Step Sizes %}

When a proposal is made to move a parameter to a new value, this proposal dose not only depend on the nature of the move (e.g., slide, scale, ...) but also the current settings of how far from the current value the new proposed one can be.
This is called the step-size of the move, and is usually determined by some parameters of the move function (e.g., the window size `delta` of the slide move).
Depending on the structure of the likelihood surface (and thus the moved parameter, the data, etc.), the appropriate step size can vary.
If the step size is too small, this can mean the chain is only approaching the optimum value very slowly, thus making the analysis inefficient.
If the step size is too large, its sampling may be too coarse to properly explore the likelihood, and/or it may overshoot the optimal values.
{{ moves_script | snippet: "block#", "5" }}

{% subsection Multiple Operators vs. Autotuning %}

The efficiency of moves is often measured in acceptance proportion -- how many times when a move was proposed during the MCMC has it actually been accepted?
When a move is only accepted very rarely, this may imply that it is not exploring the space in a sensible way (e.g., perhaps the step size is too large), and since the parameter is only updated rarely, it does not contribute much to the analysis.
On the contrary, if a move is accepted too often, this could be because the step size is too small, and is slowly moving towards some local optimum.

There are two commonly approached strategies for ensuring appropriate step sizes: using multiple moves or using autotuning.
For ultiple moves, each parameter is assigned multiple moves of the same kind, covering a range of possible moving parameters.
The desired effect of this is, that moves at different step sizes are available to the model, so that there is a good chance that an appropriate one can be suggested and accepted in different situations throughout the chain.
{{ moves_script | snippet: "block#", "6" }}
Importanlty, the parameters of these moves should _not_ be tuned during burn-in, since that would change their spacing (and likely equalize them).

The other option is to make use of the auto-tuning feature.
When the argument `tune` for a move is set to `TRUE`, the move's parameters can be tuned automatically, either during the burn-in phase, the main run, or both.
In this case, the acceptance ratio of the move is evaluated over a certain iterations-interval, and the move parameters are adjusted accordingly based on this past performance.
For both `.burnin()` and `.run()`, the parameter `tuningInterval` determines after how many generations the parameters are tuned.
While tuning the moves during burn-in is a good idea, we would advise caution for tuning during the main run, as it can lead to unintended behaviour.
Accordingly, there is not default interval for `.burnin()`, but the default for `.run()` is 0.

What is to be considered a 'good' acceptance ration can depend on the moves and the case, but common recommendations for desirable acceptance proportions range from around 0.2 to 0.4 -- the default in RevBayes is 0.44.
That value can be changed for each move individually using the argument `tuneTarget`.
{{ moves_script | snippet: "block#", "7" }}


{% subsection Diagnostics %}

As suggested above, acceptance proportion is a common way to assess whether the MCMC is well tuned.
In RevBayes, this can be checked by applying `.operatorSummary()` to the `mcmc` object once it is run.
{{ moves_script | snippet: "block#", "8" }}

We can see here that [...]

