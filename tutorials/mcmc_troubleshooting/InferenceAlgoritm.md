{% assign inference_script = "inference.Rev" %}

Inference algoritm
==================
{:.section}

An MCMC can get stuck on a local optiumum, and if that happens for long enough, it could give the impression of converge, because the sampled parameter values would seem to have stabilised. There can be various causes for this to happen, but it seems particularly common when the likelihood surface is complex and many parameters are correlated. A way how this can manifest is the presence of 'plateaus' in the trace -- parameters being stuck around the same value for a long time and then suddenly jumping to other values further away.


Independent Runs
================
{:.subsection}

A simple way to notice problems with local optima is to run several independent chains. If the resulting MCMC samples are different, this would indicate that the runs got stuck on different local optima.
{{ inference_script | snippet: "block#", "1" }}

Note that the independent chains should be initialised at different (if possible random) starting values, to make it more likely that they would end up on different local optima.


MCMCMC
======
{:.subsection}

A more elaborate way of running the analysis on a complex likelihood surface is to use Metropolis-coupled MCMC (MCMCMC or MC^3). Instead of several independent (but with regards to their setup equivalent) chains, we make use of so-called 'heated' chains.

For these additional chains, the posterior probability is raised to a power, which flattens the likelihood surface and thus lets them move faster and easier across it. This means they can explore areas in parameter space that the regular chain might not have gotten to.

However, only the likelihood and parameter values of the regular chain are being recorded, but in certain intervals, its current likelihood is compared with that of the current position of the heated chains. If their likelihood is higher, the regular chain can switch places with them and continue sampling in that region of parameter space.
{{ inference_script | snippet: "block#", "2" }}

This way, the heated chains can 'scout' the parameter space for different optima, while the regular chain can 'jump' to the highest optima that were found, instead of getting stuck at whichever it landed on first.

