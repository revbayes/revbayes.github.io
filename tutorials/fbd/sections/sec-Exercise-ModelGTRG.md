{% subsection The General Time-Reversible + Gamma Model of Nucleotide Sequence Evolution | Exercise-ModelGTRG %}

In this section we will define our nucleotide sequence evolution model.

> Open your text editor and create the molecular substitution model file
> called `{{ gtrg_script }}` in the `scripts` directory.
>
>Enter the Rev code provided in this section in the new model file.
{:.instruction}

For our nucleotide sequence evolution model, we need to define a general
time-reversible (GTR) instantaneous-rate matrix
(*i.e.* $Q$-matrix). A nucleotide GTR matrix
is defined by a set of 4 stationary frequencies, and 6 exchangeability
rates. We create stochastic nodes for these variables, each drawn from a
uniform Dirichlet prior distribution.

{{ gtrg_script | snippet:"block#","1-2" }}

We need special moves to propose changes to a Dirichlet random variable,
also known as a simplex (a vector constrained sum to one). Here, we use
a `mvSimplexElementScale` move, which scales a single element of a
simplex and then renormalizes the vector to sum to one. The tuning
parameter `alpha` specifies how conservative the proposal should be,
with larger values of `alpha` leading to proposals closer to the current
value.

{{ gtrg_script | snippet:"block#","3" }}

Then we can define a deterministic node for our GTR $Q$-matrix using the
special GTR matrix function (`fnGTR`).

{{ gtrg_script | snippet:"block#","4" }}

Next, in order to model gamma-distributed rates across, we create an
exponential parameter $\alpha$ for the shape of the gamma distribution,
along with scale proposals.

{{ gtrg_script | snippet:"block#","5-6" }}

Then we create a Gamma$(\alpha,\alpha)$ distribution, discretized into 4
rate categories using the `fnDiscretizeGamma` function. Here,
`rates_cytb` is a deterministic vector of rates computed as the mean of
each category.

{{ gtrg_script | snippet:"block#","7" }}

Finally, we can create the phylogenetic continuous time Markov chain
(PhyloCTMC) distribution for our sequence data, including the
gamma-distributed site rate categories, as well as the branch rates
defined as part of our exponential relaxed clock. We set the value of
this distribution equal to our observed data and identify it as a static
part of the likelihood using the `clamp` method.

{{ gtrg_script | snippet:"block#","8" }}

>You have completed the GTR model file. Save `model_GTRG.Rev` in
>the `scripts` directory.
{:.instruction}

We will now move on to the next model file.