---
title: Piecewise Coalescent Process
subtitle: Estimating Demographic Histories with a Piecewise Coalescent Process
authors: Ronja Billenstein and Sebastian Höhna
level: 8 #may need adjustment
order: 0.5
prerequisites:
- coalescent
index: false
include_all: false
include_files:
- data/horses_homochronous_sequences.fasta
- scripts/mcmc_homochronous_piecewise.Rev
include_example_output: true
---

{% section Overview %}
This exercise describes how to run a piecewise Skyline Analysis in `RevBayes`.
In this case, we will define an individual demographic function with different basic "pieces".
The pieces can be either constant, linear or exponential.
For all of these pieces, the different values of $N_e$ and the change points in between can be estimated.

<!--- From looking at the output of the skyline analysis, we could assume three pieces:
* a recent, constant demographic history
* an exponential population size trajectory in the middle
* and another constant piece as most ancient. --->

{% aside Definition of the different base demographic models %}
...
{% endaside %}

{% section Inference Example %}

> ## For your info
> The entire process of the skyline estimation can be executed by using the **mcmc_piecewise.Rev** script in the **scripts** folder.
> You can type the following command into `RevBayes`:
~~~
> source("scripts/mcmc_piecewiese.Rev")
~~~
We will walk you through every single step in the following section.
{:.info}

We will mainly highlight the parts of the script that change compared to the [constant coalescent model]({{base.url}}/tutorials/coalescent/constant).

{% subsection Read the data %}
Read in the data as described in the first exercise.

{% subsection The Piecewise Coalescent %}
For the piecewise model, you need to define which kinds of pieces should be included.

For each piece, one or two population sizes will be estimated.
Choose a prior and add a move for each population size.
In the case of a constant coalescent process, one population size is needed.
For the two other processes, one population size for the start of the piece and one for the end of the piece are needed.
Here, we would like to test six different pieces.
Two should be constant, two linear and two exponential.
Thus, we need five population sizes.

~~~
for (i in 1:5){
    pop_size[i] ~ dnUniform(0,1E8)
    pop_size[i].setValue(100)
    moves.append( mvScale(pop_size[i], lambda=0.1, tune=true, weight=2.0) )
}
~~~

We also set prior distributions on the times of the change points between pieces.

~~~
change_points[1] ~ dnUniform(1E4,2E4)
change_points[2] ~ dnUniform(3E4,4E4)
change_points[3] ~ dnUniform(6E4,9E4)
change_points[4] ~ dnUniform(1.2E5,1.7E5)
change_points[5] ~ dnUniform(2.2E5,3.2E5)
for (i in 1:5){
    moves.append( mvSlide(change_points[i], delta=0.1, tune=true, weight=2.0) )
}
~~~

Now, we need to define the different pieces.
Depending on the type of piece, different parameters need to be added:

~~~
dem_exp_1 = dfExponential(N0 = pop_size[1], N1=pop_size[2], t0=0, t1=change_points[1])
dem_exp_2 = dfExponential(N0 = pop_size[2], N1=pop_size[3], t0=change_points[1], t1=change_points[2])
dem_lin_1 = dfLinear(N0 = pop_size[3], N1=pop_size[4], t0=change_points[2], t1=change_points[3])
dem_const_1 = dfConstant(pop_size[4])
dem_lin_2 = dfLinear(N0 = pop_size[4], N1=pop_size[5], t0=change_points[4], t1=change_points[5])
dem_const_2 = dfConstant(pop_size[5])
~~~

{% subsection The Tree %}

Now, we will instantiate the stochastic node for the tree with `dnCoalescentDemography`.
In this case, we set the vector of demographic models and the change points as input.

~~~
psi ~ dnCoalescentDemography([dem_exp_1,dem_exp_2,dem_lin_1,dem_const_1,dem_lin_2,dem_const_2], changePoints=change_points, taxa=taxa)
~~~

For this analysis, we constrain the root age as before and add the same moves for the tree.

{% subsection Substitution Model and other parameters %}
This part is also taken from the constant coalescent exercise.

{% subsection Finalize and run the analysis %}

In the end, we need to wrap our model as before.

Finally, we add the monitors and then run the MCMC.

~~~
monitors.append( mnModel(filename="output/horses_piecewise.log",printgen=THINNING) )
monitors.append( mnFile(filename="output/horses_piecewise.trees",psi,printgen=THINNING) )
monitors.append( mnFile(filename="output/horses_piecewise_NEs.log",pop_size,printgen=THINNING) )
monitors.append( mnFile(filename="output/horses_piecewise_times.log",change_points,printgen=THINNING) )
monitors.append( mnScreen(pop_size, root_age, printgen=100) )
~~~

{% section Results %}

After running your analysis, you can plot the results using the `R` package `RevGadgets`.

<!---
{% figure example_piecewise %}
<img src="figures/horses_skyline.png" width="800">
{% figcaption %}
This is how the resulting skyline plot should roughly look like.
{% endfigcaption %}
{% endfigure %}
--->

{% section Summary %}
When you are done with all exercises, have a look at the [summary]({{base.url}}/tutorials/coalescent/summary).

