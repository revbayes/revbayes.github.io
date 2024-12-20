{% section Site-Heterogeneous Discrete Morphology Model | dm_dir %}

{% figure morpho_hyperprior_graphical_model %}
<img src="figures/tikz/morph_hyperprior.png" width="400" /> 
{% figcaption %} 
Graphical model demonstrating the Dirichlet prior to allow variable state frequencies 
in both binary and multistate data.
{% endfigcaption %}
{% endfigure %}

In the previous example, we explored allowing among-character variation
in state frequencies. This is an excellent start for allowing more
complex models for morphology. But this approach also has several
shortcomings. First, because we use a Beta distribution, this model
really only works for binary data. Secondly, oftentimes, we will not
have a good idea of the shape of the distribution from which we expect
state frequencies to be drawn.

To accommodate for these concerns, RevBayes also has a model that is
similar to the CAT model {% cite Lartillot2004 %}.

The site-heterogeneous discrete morphology model (SHDM) uses a
hyperprior on the prior on state frequencies to mix over different
possible combinations state frequencies. In this mixture model, F81
Q-matrices (an extension of the Jukes-Cantor which allows for different
state frequencies between characters) is initialized from a set of state
frequencies. The number of Q-matrices initialized is equal to the number
of user-defined categories, as in the discretized Beta model. The state
frequencies used to initialize the Q-matrices are drawn from a
Dirichelet prior distribution, which is generated by drawing values from
an exponential hyperprior distribution. This model is visualized in 
{% ref morpho_hyperprior_graphical_model %}.


{% subsection Example: Site-Heterogeneous Discrete Morphology Model %}

>Make a copy of the Rev file you just made. 
>Call it `mcmc_mk_hyperprior.Rev`. 
>It will contain the new model parameters and model.
{:.instruction}


{% subsubsection Modifying the Rev Script File %}

At each place in which the output files are specified in the MCMC file,
change the output path so you don't overwrite the output from the
previous exercise. For example, you might call your output file
`output/mk_hyperprior.log` and `output/mk_hyperprior.trees`. We will
also monitor Q_morpho and pi. Add Q_morpho and pi to the `mnScreen`.
Change source statement to indicate the new model file.


We need to modify the way in which the $Q$-matrix is specified. 
First, we will create a hyperprior called `dir_alpha` and specify a move on it.
```
dir_alpha ~ dnExponential(1)
moves.append( mvScale(dir_alpha, lambda=1, weight=2.0 ) )
```
This hyperparameter, dir_alpha, will be used as a parameter to a
Dirichelet distribution from which our state frequencies will be drawn.
```
pi_prior := v(dir_alpha,dir_alpha)
```
If you were using multistate data, the dir_alpha can be repeated for
each state. Next, we will modify our previous loop to use these state
frequencies to initialize our Q-matrices.
```
for(i in 1:n_cats) {
	pi[i] ~ dnDirichlet(pi_prior)
    moves.append( mvSimplexElementScale(pi[i], alpha=10, weight=1.0) )
    
    Q_morpho[i] := fnF81(pi[i])
}
```
In the above loop, for each of our categories, we make a new draw of
state frequencies from our Dirichelet distribution (the shape of which
is determined by our dir_alpha values). We then use `fnF81` to make our
Q-matrices. For each RevBayes iteration, we will have 4 pi values and
4 Q-matrices, one for each of the number of categories we specified.

No other aspects of the model file need to change. Run the MCMC as
before.




{% subsection Evaluate and Summarize Your Results | trace %}



{% subsubsection Evaluate MCMC | subsubsec_Eval_MCMC %}

We will use `Tracer`to evaluate the MCMC samples from our
three estimations. Load all three of the MCMC logs into the
`Tracer` window. The MCMC chains will not have converged
because they have not been run very long. Highlight all three files in
the upper left-hand viewer ({% ref add_files %}) by right- or
command-clicking all three files.


{% figure add_files %}
<img src="figures/AddFiles.png" width="50%"/> 
{% figcaption %} 
Highlight all three files for model comparison.
{% endfigcaption %}
{% endfigure %}

Once all three trace logs are loaded and highlighted, first look at the
estimated marginal likelihoods. You will notice that the Mk model, as
originally proposed by {% cite Lewis2001 %} is improved by allowing any state
frequency heterogeneity at all. The discretized model and the Dirichlet
model both represent improvements, but are fairly close in likelihood
score to each other ({% ref tracer_llik %}). Likely, we would need to
perform stepping stone model assessment to truly tell if the more
complicated model is statistically justified. 
This analysis is too complicated and time-consuming for this tutorial period, 
but you will find instructions for performing the analysis in
{% page_ref model_selection_bayes_factors/bf_intro %}.

{% figure tracer_llik %}
<img src="figures/likelihoods.png" width="100%"/> 
{% figcaption %} 
Comparison of likelihood scores for all three models.
{% endfigcaption %}
{% endfigure %}
 

Click on the `Trace` panel. In the lower left hand corner, you will
notice an option to color each trace by the file it came from. Choose
this option (you may need to expand the window slightly to see it). Next
to this option, you can also see an option to add a legend to your trace
window. The results of this coloring can be seen in
{% ref coltrace %}. When the coloring is working, you will see that
the Mk model mixes quite well, but that mixing becomes worse as we relax
the assumption of equal state frequencies. This is because we are
greatly increasing model complexity. Therefore, we would need to run the
MCMC chains longer if we were to use these analyses in a paper.

{% figure coltrace %}
<img src="figures/colortrace.png" width="80%"/> 
{% figcaption %} 
The Trace window. The traces are colored by which version of the Mk model 
they correspond to.
{% endfigcaption %}
{% endfigure %}

We are interested in two aspects of the posterior distribution. First,
all analyses correct for the biased sampling of variable characters
except for the simple analysis. Then, we expect the
tree_length variable to be greater for simple
than for the remaining analyses, because our data are enriched for
variation. {% ref tracer_tree_length %} shows that
`tree_length` is approximately 30% greater for
simple than for `mk_simple`, which are
identical except that `mk_simple` corrects for sampling
bias. To compare these densities, click the “Marginal Prob Distribution”
tab in the upper part of the window, highlight all of the loaded Trace
Files, then select `tree_length` from the list of Traces.

{% figure tracer_tree_length %}
<img src="figures/results/tracer_tree_length.png" width="50%" /> 
{% figcaption %} 
Posterior tree length estimates.
{% endfigcaption %}
{% endfigure %}

Second, we are interested in characterizing the degree of heterogeneity
estimated by the beta-discretized model. If the data were distributed by
a single morphological rate matrix, then we would expect to see very
little variation among the different values in cats, and
very large values for the shape and scale parameters of the
discrete-beta distribution. For example, if alpha_ofbeta =
beta_ofbeta = 1000, then that would cause all discrete-beta
categories to have values approaching 0.5, which approximates a
symmetric Mk model.

{% figure tracer_cats %}
<img src="figures/results/cats.png" width="50%" /> 
{% figcaption %} 
Posterior discretized state frequencies for the discrete-beta model.
{% endfigcaption %}
{% endfigure %}

{% figure tracer_alpha_beta %}
<img src="figures/results/alpha_beta.png" width="50%" /> 
{% figcaption %} 
Posterior alpha and beta parameters for the discrete-beta model.
{% endfigcaption %}
{% endfigure %}

{% ref tracer_cats %} shows that the four discrete-beta state
frequencies do not all have the exact same value. In addition,
{% ref tracer_alpha_beta %} shows that the priors on the
discrete-beta distribution are small enough that we expect to see
variance among cat values. If the data contained no
information regarding the distribution of cat values, then
the posterior estimates for alpha_ofbeta and
beta_ofbeta would resemble the prior.


{% subsubsection Summarizing tree estimates %}

The morphology trees estimated in Section {% ref sec_mk_model_analysis %} and
Section {% ref sec_discretized_analysis %} are summarized using a majority rule consensus tree
(MRCT). Clades appearing in $p>0.5$ of posterior samples are resolved in
the MRCT, while poorly support clades with $p \leq 0.5$ are shown as
unresolved polytomies. Poor phylogenetic resolution might be caused by
having too few phylogenetically informative characters, or it might be
due to conflicting signals for certain species relationships. Because
phylogenetic information is generated through model choice, let's
compare our topological estimates across models.

{% figure mk_discretized_majrule %}
<img src="figures/results/mk_discretized_majrule_tre.png" width="75%" /> 
{% figcaption %} 
Majority rule consensus tree for the beta-discretized Mkv analysis.
{% endfigcaption %}
{% endfigure %}

The MRCTs for the simple model with and without the +v correction are
very similar to that for the discretized-beta model
({% ref mk_discretized_majrule %}). Note that the scale bars for
branch lengths differ greatly, indicating that tree length estimates are
inflated without the +v correction, just as we saw when comparing the
posterior tree length densities. In general, it is important to assess
whether your results are sensitive to model assumptions, such as the
degree of model complexity, and any mechanistic assumptions that
motivate the model's design. In this case, our tree estimate appears to
be robust to model complexity.
