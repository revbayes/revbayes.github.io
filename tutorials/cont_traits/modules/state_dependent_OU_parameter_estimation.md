{% section Testing hypotheses of state-dependent evolution with the OU Model %}

The relaxed OU model detects shifts of the optimum on a phylogeny without assuming what caused (or is correlated with) the shifts.
Sometimes however, we are interested in whether, or how, some specific variables contributed to the continuous character evolution.
Here, we use the state-dependent OU model to infer (1) discrete character history and (2) discrete-state-dependent continuous character evolution.
Similar to {% citet Beaulieu2012 %}, this model supports multiple $\alpha$, $\sigma^2$, and $\theta$, allowing us to infer changes in the optimal value as well as the rates of evolution/adaptation.

Conventionally, a sequential approach is used to infer discrete state-dependent continuous character evolution -- we first reconstruct the discrete character history, then infer continuous character evolution on the discrete character map(s) (e.g., {% citet Hansen1997 %}).
Alternatively, a joint approach can be used to infer evolution of both characters simultaneously while taking their dependence into account (e.g., {% citet Boyko2023 %}).
The state-dependent OU model in RevBayes can perform both.
In this tutorial, we will focus on the joint approach, where the discrete character history is treated as a random variable and can be modified using a data-augmentation approach.

{% figure fig_ou_sd_gm %}
<img src="figures/state_dependent_ou_gm.pdf" width="50%" height="50%" />
{% figcaption %}
The graphical model representation of the state-dependent Ornstein-Uhlenbeck (OU) process using a joint-inference approach. For more information about graphical model representations see {% citet Hoehna2014b %}.
{% endfigcaption %}
{% endfigure %}

In this tutorial, we use a time-calibrated phylogeny of 97 Diprotodontia from { % citet something % } and datasets of (log) body size and herbivory from {% cite PHYLACINE %} to test diet dependency in body size evolution.

&#8680; The full state-dependent OU-model specification is in the file called `mcmc_state_dependent_OU.Rev`.

{% subsection Read the data %}

We begin by deciding which of the characters to use.
Here, we assume we are analyzing the first discrete character (diet) and first continuous character (body mass).
```
char_disc <- 1
char_cont <- 1
```

Now, we read in the phylogenetic tree.
```
tree <- readTrees("data/diprotodontia_tree.nex")[1]
```
We also want to keep track of the number of branches for our relaxed clock model.
```
ntips     <- tree.ntips()
nbranches <- 2 * ntips - 2
```

Next, we read in the discrete character data.
We have to exclude all other characters that we are not interested in and only include our focal trait.
This can be done in RevBayes using the member methods `.excludeAll()` and `.includeCharacter()`.
```
disc <- readContinuousCharacterData("data/primates_disc_traits.nex")
disc.excludeAll()
disc.includeCharacter( char_disc )
num_disc_states <- disc.getStateDescriptions().size()
```

Similarly, we read in the continuous character data.
```
cont <- readContinuousCharacterData("data/primates_cont_traits.nex")
cont.excludeAll()
cont.includeCharacter( char_cont )
```

We initialize a variable for our vector of
moves and monitors.
We add one adaptable variance multivariate normal (AVMVN) kernel for each of the discrete and continuous models to improve mixing of MCMC traces.
```
moves    = VectorMoves()
monitors = VectorMonitors()
avmvn_disc = mvAVMVN(weight=20, waitBeforeLearning=500, waitBeforeUsing=1000)
avmvn_cont = mvAVMVN(weight=20, waitBeforeLearning=500, waitBeforeUsing=1000)
```

{% subsection Specify the model %}

{% subsubsection The discrete character model %}

We create a vector of transition rates drawn from a Dirichlet prior. 
```
num_type_transition <- num_disc_states * (num_disc_states - 1)
rates ~ dnDirichlet( rep(1, num_type_transition) )
moves.append( mvBetaSimplex( rates, weight=2 ) )
moves.append( mvDirichletSimplex( rates, weight=2 ) )
avmvn_disc.addVariable( rates )
```

We build the rate matrix and set the rescaled argument as TRUE.
```
Q := fnFreeK( rates, rescaled=TRUE )
```

Next, we assign a prior to the rescaling factor of the rate matrix.
```
lambda ~ dnExponential(200)
moves.append( mvScale(lambda, weight=1.0) )
avmvn_rates.addVariable(lambda)
```
After including all parameters in the discrete model to avmvn_disc, we add avmvn_disc to our moves vector.
```
moves.append( avmvn_disc )
```

We set up the CTMC model.
Note that it is a different from the one used for stochastic mapping.
```
X ~ dnPhyloCTMCDASiteIID(tree, Q, branchRates=lambda, type="Standard", nSites=1)
X.clamp(disc)
```

We include proposals for the discrete character history.
Node proposal changes the state of a randomly chosen node, as well as its parent branch and daughter branches. 
Path proposal changes the state along a branch while the states of the parent node and the child node do not change.
```
moves.append( mvCharacterHistory(ctmc=X, qmap_site=Q, graph="node",   proposal="rejection", weight=100.0) )
moves.append( mvCharacterHistory(ctmc=X, qmap_site=Q, graph="branch", proposal="rejection", weight=50.0) )
```

We keep track of the number of transitions.
```
for(i in 1:nbranches) {
    num_changes[i] := sum(X.numCharacterChanges(i))
}
total_num_changes := sum(num_changes)

char_hist := X.characterHistories()
```

{% subsubsection The OU model %}
First, we set up the optimum parameter.
for (i in 1:num_disc_states){
  theta[i] ~ dnUniform(-10, 10)
  moves.append(mvSlide(theta[i], weight = 1.0) )
  avmvn_ou.addVariable(theta[i])
}


We retrieve some information from our data before proceeding.
```
root_age <- tree.rootAge()
v_emp <- cont.var(char_cont)
```

There are two options to assign priors to $\alpha$ and $\sigma^2$.
On one hand, we can directly put priors on the parameters.
```
for (i in 1:num_disc_states){
  alpha[i] ~ dnExponential(root_age/2/ln(2))
  moves.append(mvScale(alpha[i], weight = 1.0) )
  avmvn_cont.addVariable(alpha[i])

  sigma2[i] ~ dnLognormal(ln(sqrt(v_emp), 0.587405))
  moves.append(mvScale(sigma2[i], weight = 3.0) )
  avmvn_cont.addVariable(sigma2[i])
}
```

Alternatively, we can assign a hyperprior for phylogenetic half-life ($ln(2)/\alpha$) and stationary variance ($sigma^2/2\alpha$) respectively, and transform the parameters to $\alpha$ and $\sigma^2$.
The advantage of this option is that phylogenetic half-life and stationary variance have clearer biological meanings and can be interpreted intuitively.
```
for (i in 1:num_disc_states){
  t_half[i] ~ dnLognormal(ln(root_age/2), 0.587405)
  moves.append(mvScale(t_half[i], weight = 1.0) )
  avmvn_cont.addVariable(t_half[i])
  alpha[i] := abs(ln(2)/t_half[i])

  Vy[i] ~ dnLognormal(ln(v_emp), 0.587405)
  moves.append(mvScale(Vy[i], weight = 3.0) )
  avmvn_cont.addVariable(Vy[i])
  sigma2[i] := Vy[i] * 2 * alpha[i]
}
```
Note that the prior distributions of the two options are _not_ equivalent.



All paramters in the OU model go to avmvn_cont.
```
moves.append( avmvn_ou )
```

{% The state-dependent OU model %}
Now that we have specified the state-dependent parameters, we can draw the discrete model and the character data from the corresponding phylogenetic OU model.
```
Y ~ dnPhyloOUSD(char_hist, theta=theta, rootTreatment="optimum", alpha=alpha, sigma=sigma2^0.5)
Y.clamp(cont)
```

Noting that $y$ is the observed data ({% ref fig_ou_relaxed_gm %}), we clamp the `cont` to this stochastic node.
```
Y.clamp(data)
```

Finally, we create a workspace object for the entire model with `model()`.
Remember that workspace objects are initialized with the `=` operator, and are not themselves part of the Bayesian graphical model.
The `model()` function traverses the entire model graph and finds all the nodes in the model that we specified.
This object provides a convenient way to refer to the whole model object, rather than just a single DAG node.

```
mymodel = model(Y)
```

{% subsection Running an MCMC analysis %}

{% subsubsection Specify Monitors %}

For our MCMC analysis, we need to set up a vector of *monitors* to record the states of our Markov chain. The monitor functions are all called `mn*`, where `*` is the wildcard representing the monitor type.
First, we will initialize the model monitor using the `mnModel` function.
This creates a new monitor variable that will output the states for all model parameters when passed into a MCMC function.
```
monitors.append( mnModel(filename="output/trace.log", printgen=10) )
```
Additionally, create a screen monitor that will report the states of
specified variables to the screen with `mnScreen`:
```
monitors.append( mnScreen(printgen=1000, theta) )
```
Finally, we include a monitor for the character history on each branch.
```
monitors.append( mnFile( char_hist, filename="output/char_hist.trees", printgen=10 ) )
```

{% subsubsection Initialize and Run the MCMC Simulation %}

With a fully specified model, a set of monitors, and a set of moves, we
can now set up the MCMC algorithm that will sample parameter values in
proportion to their posterior probability. The `mcmc()` function will
create our MCMC object:
```
mymcmc = mcmc(mymodel, monitors, moves, nruns=2, combine="mixed")
```
Now, run the MCMC:
```
mymcmc.run(generations=50000, burnin=200)
```

Since the character history output is in simmap format, we will convert it to ancestral map format in R and summarize it in RevBayes.
We hope to simplify the process in the future. 
Start R in the main directory for this analysis and then type the following commands:
```R
source("scripts/plot_helper_state_dependent_OU.R")

tree <- read.nexus("data/diprotodontia_tree.nex")
simmap_to_ancStates("output/char_hist.trees", "output/anc_states.log", tree)

```

Now, go back to RevBayes and type the following commands:
```rb
file_in <- "output/anc_states.log"
file_out <- "output/anc_states.tre"

anc_states = readAncestralStateTrace(file_in)
anc_tree = ancestralStateTree(tree=tree,
                              ancestral_state_trace_vector=anc_states,
                              include_start_states=false,
                              file=file_out,
                              summary_statistic="MAP",
                              reconstruction="marginal",
                              burnin=0.1,
                              nStates=3,
                              site=1)
# nStates should always be >= 3 even if your character is binary
q()
```

Finally, open R again to plot the objects:
```R
library(RevGadgets)
source("scripts/plot_helper_state_dependent_OU.R")

tree <- readTrees("data/diprotodontia_tree.nex")

# plot the objects
ase <- processAncStates("output/anc_states.tre",
                        state_labels=c("0"="non-herbivore", "1"="herbivore"))

p1 <- plotAncStatesMAP(t = ase,
                       tip_labels = FALSE,
                       node_color_as = "state",
                       node_color = c("non-herbivore"="#88ccee", "herbivore"="#999933"),
                       node_size = c(1, 3),
                       tip_states = TRUE,
                       tip_states_size = 2,
                       state_transparency = 0.7,
) +
  # modify legend location using ggplot2
  theme(legend.position.inside = c(0.6,0.8))

p2 <- plotAncStatesPie(t = ase,
                       pie_colors = c("non-herbivore"="#88ccee", "herbivore"="#999933"),              
                       node_pie_size = 3,
                       tip_pies = TRUE,
                       tip_pie_size = 2
                       state_transparency = 0.7,
                       tip_labels = FALSE,         
) +
  # modify legend location using ggplot2
  theme(legend.position.inside = c(0.6,0.8))


char_hist <- read.table("output/char_hist.trees", header=TRUE)
simmaps <- read.simmap(text=char_hist$char_hist, format="phylip")
stoc_map <- processStochMaps(tree,
                             simmap = simmaps,
                             states=c("0", "1"))

colnames(stoc_map)[6] = "non-herbivore"
colnames(stoc_map)[7] = "herbivore"

p3 <- plotStochMaps(tree, maps=stoc_map,
                    tip_labels = FALSE,
                    tree_layout = "rectangular",
                    color_by = "MAP",
                    colors = c("non-herbivore" = "#88ccee",
                               "herbivore" = "#999933"),
                    line_width = 0.5) +
  theme(legend.position.inside = c(0.6,0.8))

trace <- readTrace("output/trace.log", burnin = 0.1)
color_diet <- c("#88ccee", "#999933")
names(color_diet) <- c("t_half[1]", "t_half[2]")
p4 <- plotTrace(trace, vars = c("t_half[1]", "t_half[2]"), color = color_diet)[[1]] +
  ggtitle("Phylogenetic half-life") +
  theme(legend.position = "none") +
  xlab("Time (tree height)") +
  ylab("Posterior probability density")

names(color_diet) <- c("Vy[1]", "Vy[2]")
p5 <- plotTrace(trace, vars = c("Vy[1]", "Vy[2]"), color = color_diet)[[1]] +
  ggtitle("Stationary variance") +
  theme(legend.position = "none",
        axis.title.y = element_blank()) +
  xlab("ln(body mass (kg))^2") +
  xlim(0, 100)

names(color_diet) <- c("theta[1]", "theta[2]")
p6 <- plotTrace(trace, vars = c("theta[1]", "theta[2]"), color = color_diet)[[1]] +
  ggtitle("Optimum") +
  theme(axis.title.y = element_blank()) +
  xlab("ln(body mass (kg))") +
  theme(legend.position = "none",
        axis.title.y = element_blank())
  
legend <- get_legend2(p6 + theme(legend.position = "left",
                                 legend.box.margin = margin(0, 0, 0, 12))
                               + guides(color = guide_legend(title='Diet'),
                                        fill=guide_legend(title='Diet'))
                               + scale_fill_discrete(name = "Diet")
                               + scale_color_manual(values=c("#88ccee", "#999933"), 
                                                name="Diet",
                                                labels=c("non-herbivore", "herbivore")))
  
row1 <- cowplot::plot_grid(p1, p2, p3, ncol=3)
row2_left <- cowplot::plot_grid(p4, p5, p6, ncol=3)
row2 <- cowplot::plot_grid(row2_left, legend, ncol=2, rel_widths = c(1, 0.3))
plot <- cowplot::plot_grid(row1, row2, ncol=1, rel_heights=c(3,2))


```

{% figure fig_state_dependent_OU %}
<img src="figures/state_dependent_OU.pdf" width="50%" height="50%" />
{% figcaption %}
**Top row: Estimated discrete character history on the phylogeny. Bottom row: Estimated state-dependent OU parameters.**
Here we show the results of our example analysis.
{% endfigcaption %}
{% endfigure %}



