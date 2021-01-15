{% subsection Exercise 1 %}

- Run an MCMC simulation to estimate the posterior support for mass extinctions.
- Visualize the support using `R`.
- Do you see evidence for mass extinctions? When? What known mass extinction event, if any, does this correspond to?
- Plot the continuous rates of speciation, extinction, and fossilization (revisit the {% page_ref divrate/ebd %} tutorial for details). What patterns do you see?
- Is there evidence for rate variation? Look at the estimates of `speciation_global_scale`, `extinction_global_scale`, and `fossilization_global_scale` in `Tracer`: Is there information in the data to change the estimates from the prior?

{% subsection Exercise 2 %}

- Assess prior sensitivity. Specifically, assess the sensitivity of the results to the prior expected number of mass extinctions.
	1. Set `expected_number_of_mass_extinctions` to something other than 1.0, like 0.5 or 2.0 (or even something much smaller or bigger like 0.1 or 10).
	2. Run the new analysis and plot the results.
- How does this influence your support for mass extinctions?
- Do the continuous rates of speciation, extintion, and/or fossilization change?
