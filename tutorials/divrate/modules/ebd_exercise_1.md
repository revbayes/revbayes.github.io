{% subsection Exercise 1 %}

- Run an MCMC simulation to estimate the posterior distribution of the speciation rate and extinction rate.
- Visualize the rate through time using `R`.
- Do you see evidence for rate decreases or increases? What is the general trend?
- How much faster is the `net-diversification` rate at the present compared to the most ancient time interval?
- Is there evidence for rate variation? Look at the estimates of `speciation_sd` and `extinction_sd` in `Tracer`: Is there information in the data to change the estimates from the prior?
- Run the analysis using a different number of intervals, *e.g.,* 5 or 50. How do the rates change?


{% subsection Exercise 2 %}

- In our results we see that the extinction rate is fairly constant. Modify the model by using a constant-rate for the extinction rate parameter but still let the speciation rate vary through time.
	1. Remove all previous occurrences of the extinction rates (*i.e.,* priors, parameters and moves).
	2. Specify a lognormal prior distribution on the constant extinction rate (`extinction ~ dnLognormal(-5,sd=2*0.587405)`)
	3. Add a move for the new extinction rate parameter `moves.append( mvScale(extinction,weight=5.0) )`.
	4. Remove the argument `muTimes=interval_times` from the birth-death process.
- How does this influence your estimated rates?


