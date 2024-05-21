{% assign startingvals_script = "startingvals.Rev" %}

Starting Values
===============
{:.section}

The MCMC chain has to have a starting point from which to begin proposing new parameter values.
Thus, it is 'initialized' with some random values (usually drawn from the priors).
This makes sense, because the MCMC should be able to find the optimal parameter values from any starting point, and one would want to avoid introducing bias via the starting position (e.g. starting on top of a local optimum).

However, in practice it is possible to start the chain at a 'bad' position, which will impact the analysis negatively.
In the easiest cases, this can mean that we start at a point in parameter space that is very far away from the area where the optimum lies.
This can result in the analysis runtime to be unnecessarily long (and tuning during those stretches of the chain can mis-tune the moves for when they enter the parameter space near the optima).
In the trickier cases, this can mean that our starting point is at a combination of parameter values that are implausible or even conflicting, which makes it hard to calculate a likelihood, or may even crash the analysis altogether.

When an analysis is likely to crash upon starting or to take a long time to get going, strategically setting some starting values to reasonable positions may be a simple way to fix it.
In RevBayes, starting values can be set for any parameter after their prior distribution is specified, using the function `.setValue()`.
{{ startingvals_script | snippet: "block#", "1" }}

It may not be immediately clear what a 'reasonable' starting value for a parameter should be, and in more complex analyses it may be challenging to find out which of the many moving parts of the analysis are in conflict with one another.
But revisiting what the parameters stand for, and how they relate to one another -- perhaps by visualizing the chosen prior distributions and the model's DAG -- is usually a good way of getting a better sense for what might be a good way forward.
A few strategies have become common:
- Set the starting values to the mean value of the prior (assuming the prior is appropriate)
- Set diversification rates to what would be expected given the number of species and age of the clade, e.g., using the Kendall-Moran estimate for the speciation rate ($\lambda = ln(nTips/2) / rootAge$), and setting extinction to be an order of magnitude lower than that ($\mu = \lambda/10$).
- Consider coordinating the starting values of parameters that are known to be dependent on each other, e.g., rates of evolution and branch lengths.
- Instead of starting with a random topology, supply a starting tree that is reasonably closer to the expected result, by using the output of a faster method (e.g., maximum likelihood or neighbour-joining) or a hand-curated topology. But importantly, make sure the starting tree does not violate any of the additional settings, e.g., calibrated nodes have to be within the age-range they are being calbrated to, and taxa that are constrained to be monophyletic have to form clades in the starting tree too.

But remember that we are not trying to come up with spot-on estimates for each parameter, just a value that seems reasonable enough for our data that it provides a good starting point. The primary goal is to avoid early crashes due to computational issues and auto-tuning issues, and to help speed up the analysis.

In order to still try and avoid bias, it may be prudent to run several runs with different starting values (in the same logic as it is done with random starting points), and check whether they converge on the same values.
  
