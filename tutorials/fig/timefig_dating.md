---
title: Biogeographic dating using the TimeFIG model
subtitle: Using the TimeFIG model to jointly infer divergence times and biogeographic history
authors:  Michael Landis, Sarah Swiston, Isaac Lichter Marck, Fabio Mendes, Felipe Zapata
level: 8
order: 11
prerequisites:
  - ctmc
  - clocks
  - fig/fig_intro
  - fig/geosse_model
  - fig/fig_model
  - fig/timefig_model
include_all: false
index: true
---

{% section WARNING: INCOMPLETE %}

{% section Overview %}

This tutorial explores how to perform a biogeographic dating analysis using the TimeFIG model. In its simplest form, this procedure jointly estimates phylogenetic divergence times, molecular substitution rates, biogeographic rates, and ancestral species ranges. The tutorial provides a conceptual background on challenges related to dating molecular phylogenies, alternative techniques for dating, and a framework to assess the sensitivity of divergence time estimates to methodological assumptions. 

{% subsection Background on biogeographic dating %}

Genetic data are critical to estimate phylogenetic relationships among living species. In general, genetic content is more similar among closely related species, and less similar among more highly divergent species. As mutations accumulate within a genome that is inherited across generations over time, the distances in genetic similarity will increase as phylogenetic lineages increasingly diverge over time.

Molecular phylogenetic models use these estimates of genetic distance to infer phylogenetic divergence, in terms of topology (relationships among lineages) and branch lengths (distances along lineages). Phylogenetic models often measure genetic distances in units of *expected substitutions per site*. These distances are, in fact, the product of time (e.g. millions of years) and the substitution rate (substitutions per site per time). This substitution rate is often called the *molecular clock* {% cite Zuckerkandl1967 %}. An accurate estimate of such a clock rate would enable *molecular dating*, because a research would only need to convert molecular distances into clock "ticks" to estimate the ages of species in units of geological time.

Ideally, a molecular phylogenetic model would be able to decompose branch length estimates into separate estimates of substitution rates and evolutionary time. In real biological settings, we never know the precise time or rate underlying a molecular distance, and they must both be estimated. The problem is there are an infinite number of products of rate, $r$, and time, $t$, that equal a given distance, $d$. For example, the products of $r=10, t=1$ and $r=2, t=5$ both yield $d=10$. Scenarios of a fast evolution over a short time and slow evolution over a long time produce the same amount of evolutionary change, and are not statistically identifiable from one another.  

In practice, biologists use extrinsic evidence to "calibrate" the molecular clock to a geological timescale. Fossil evidence can be used to constrain the minimum age of a phylogenetic divergence event (e.g. a child species cannot be older than its parent species), which effectively constrains time and, indirectly, rate estimates. Two main approaches have been used to deploy fossil-based calibrations. Prior-based calibrations assign a node age distribution to internal nodes on a phylogeny, selected and specified using expert knowledge. Process-based calibrations explicitly incorporate fossil morphology and ages as data during phylogenetic inference to assign ages to clades. Read these excellent papers to read more about fossil-based dating. 

Paleogeography provides a complementary source of information to estimate divergence times through *biogeographic dating*. Biogeographic dating is often used for studying clades that possess no useful fossils (e.g. clades of island plants, like *Kadua*). The logic for biogeographic dating is as follows: imagine a clade of ten species that are endemic to a volcanic island that is less than one million years old. If it is assumed a single lineage colonized the island after it emerged, then the maximum age of the clade must be younger than the island, allowing the biologist to calibrate the molecular clock.

Biogeographic dating has typically relied on prior-based constraints, requiring that the biologist makes strong assumptions about many unknowable factors: the timing and effect of paleogeographic events the dispersal abilities of species, relationships among species, and more. In addition, using a biogeographic hypothesis to date a clade (e.g. "we assume the islands were colonized after they originate") means that dated phylogeny cannot be safely used to test downstream biogeography hypotheses ("when were the islands first colonized by the clade?"). Doing so would be circular.

Biogeographic dating with a process-based approach uses paleogeographically-informed biogeographic rates to extract information about divergence times through a dataset (Landis 2020). Previous approaches for process-based biogeographic dating relied on simpler models that did not consider how speciation and extinction rates vary among regions over time {% cite Landis2017 Landis2018 %}. TimeFIG models this important relationship between paleogeographically-varying features, species ranges, biogeographic rates, and divergence times.

{% subsection Tutorial structure %}

This tutorial builds up to a process-based biogeographic dating analysis using the TimeFIG model. It begins with a simple molecular phylogenetic analysis that has *no* capability for time calibration. Then, we'll repeat the analysis using a prior-based biogeographic node age calibration. Lastly, we'll perform a process-based TimeFIG analyses to estimate divergence times.

As with previous tutorials in this series, we will analyze a dataset for Hawaiian *Kadua* plant species. All input datasets are the same as before, with the addition of 10 new homologous genetic markers obtained from the Angiosperms353 protocol.

Because these analyses build on each other, the tutorial focuses on what changes between the scripts. This tutorial is also bundled with RevBayes scripts that complete analyses equivalent to those written below. However, the scripts are often designed to be more modular and general, making them ideal to customize for analyses of new datasets, other than Hawaiian *Kadua*.


{% section Molecular phylogenetics %}

First, we'll run a simple molecular phylogenetic analysis *without* any information to time-calibrate the tree. The tutorial reviews several important concepts for phylogenetic tree estimation, such as the relaxed molecular clock. It also demonstrates that extrinsic (non-molecular) evidence is needed to time-calibrate divergence times using standard phylogenetic approaches.

For this example, we'll compose a model where the phylogeny was generated by a constant-rate birth-death process and genes evolve under a relaxed molecular clock. We'll refer to this as the `BDP_uncalibrated` analysis.

Now to get started! First, we create variables to locate input datasets.

```
analysis      = "BDP_uncalibrated"
dat_fp        = "./data/kadua/"
phy_fn        = dat_fp + "kadua.tre"
calib_fn      = dat_fp + "kadua_calib.csv"
out_fn        = "./output/" + analysis
```

We'll also create variables to locate additional RevBayes scripts, which can be loaded using `source()` rather than typing all the code by hand.

```
mol_code_fn   = "./scripts/timefig_dating/mol_timeFIG.Rev"
phylo_code_fn = "./scripts/timefig_dating/phylo_BDP.Rev"
clade_fn      = "./scripts/timefig_dating/clade.Rev" 
```

Set empty vectors for moves and monitors, to be populated later.
```
moves = VectorMoves()
monitors = VectorMonitors()
```

Next, we read in a phylogenetic tree. To simplify this analysis, we assume the tree topology is known (fixed) while the divergence times are unknown (estimated). We will use the first (only!) tree stored in `phy_fn` to define the topology.

```
phy          <- readTrees(phy_fn)[1]
taxa         = phy.taxa()
num_taxa     = taxa.size()
num_branches = 2 * num_taxa - 2
```

After that, we read in 10 molecular sequence alignments, each one corresponding to a different Angiosperms353 locus.

```
mol_idx = [ 5339, 5398, 5513, 5664, 6038, 6072, 6238, 6265, 6439, 6500 ]
num_loci = mol_idx.size()
for (i in 1:num_loci) {
    mol_fn[i] = dat_fp + "genes/kadua_" + mol_idx[i] + "_supercontig.nex"
    dat_mol[i] = readDiscreteCharacterData(mol_fn[i])
    num_sites[i] = dat_mol[i].nchar()
}
```


```
for (i in 1:num_loci) {
    dat_mol[i].excludeTaxa(dat_mol[i].taxa())
    dat_mol[i].includeTaxa(taxa[i].getName())
    dat_mol[i].addMissingTaxa(taxa[i].getName())
}
```

Next, we will manually configure the birth-death model by entering commands. In the future, you can instead load the birth-death phylogenetic model setup definition using `source( phylo_code_fn )`.

We first assign priors to the net diversification rate (birth - death) and turnover proportion (ratio of death to birth events). Net diversification rate controls how rapidly species accumuluation, whereas turnover proportion controls the speed of extinction relative to speciation. This parameterization often behaves better for model fitting, and many biologists prefer to think in these terms. 

```
diversification ~ dnExp(1)
turnover ~ dnBeta(2,2)
birth := diversification / abs(1.0 - turnover)
death := birth * turnover
```

We have most, but not all, taxa. Tell model about missing taxa.

```
# see ref Lorence 2010
n_total <- 32
n_sample <- 27
rho <- n_sample / n_total
```

Set up root age prior. Note, we will modify this in the next section.

```
root_age ~ dnUniform(0.0, 32.0)
root_age.setValue(tree_height)

moves.append( mvScale(root_age, weight=15) )
```

Set up tree model, constant rate birth death process.

```
timetree ~ dnBDP(lambda=birth,
                 mu=death,
                 rho=rho,
                 rootAge=root_age,
                 samplingStrategy="uniform",
                 condition="time",
                 taxa=taxa)

moves.append( mvNodeTimeSlideUniform(timetree, weight=2*num_taxa) )
```

We now initialize the `timetree` variable with the phylogeny we read from file, stored in `phy`.
```
timetree.setValue(phy)
```

We want the crown node ages of important clades in Hawaiian *Kadua* to appear in our MCMC trace file. Calling `source( clade_fn )` will construct six clades based on predefined *Kadua* taxon sets. We then create deterministic nodes to track the crown node ages of these clades using the `tmrca()` function, which will be monitored.

```
source(clade_fn)
age_ingroup := tmrca(timetree, clade_ingroup)
age_affinis := tmrca(timetree, clade_affinis)
age_centrantoides := tmrca(timetree, clade_centrantoides)
age_flynni := tmrca(timetree, clade_flynni)
age_littoralis := tmrca(timetree, clade_littoralis)
age_littoralis_flynni := tmrca(timetree, clade_littoralis_flynni)
```

Now we have a variable representing our phylogeny. Next, we'll model how molecular variation accumulates over time. For this, we will construct a partitioned substitution model with a relaxed molecular clock. This means rates of molecular evolution can vary among branches, among loci, and among sites. This can all be loaded by calling `source( mol_code_fn )`, but you should specify the model by hand to better understand its composition.

First, we create the relaxed clock model. The following code creates a vector of clock rates that are lognormally distributed. Later, the rates in this vector will be used to define branch-varying clock rates. To do so, we first define a base clock rate, `mu_mol_base`

```
mu_mol_base ~ dnExp(10)
moves.append(mvScale(mu_mol_base, weight=5) )
```

Then, we draw branch rates whose mean equals that base clock rate and the 2.5% and 97.5% quantiles of rate variation span one order of magnitude (determined by the magic number `0.587405`).

```
mu_mol_sd <- 0.587405
for (i in 1:num_branches) {
    ln_mean := ln(mu_mol_base) - 0.5 * mu_mol_sd * mu_mol_sd
    mu_mol_branch[i] ~ dnLnorm(ln_mean, mu_mol_sd)
    moves.append(mvScale(mu_mol_branch[i], weight=1))
}
```

In a partitioned analysis, each locus has its own evolutionary rates. We will assign each locus its own rate scaling factor, rate matrix, and site-rate variation parameters. 

To model among-locus rate variation, we fix the relative rate factor for the first locus to 1, while remaining loci have relative rate factors that follow a mean-1 Gamma distribution.

```
for (i in 1:num_loci) {
    mu_mol_locus_rel[i] <- 1.0
    if (i > 1) {
        mu_mol_locus_rel[i] ~ dnGamma(2,2)
        moves.append(mvScale(mu_mol_locus_rel[i], weight=3))
    }
    mu_mol[i] := mu_mol_locus_rel[i] * mu_mol_branch
}
```

Next, we specify the HKY rate matrix, `Q_mol` to define transition rates among nucleotides. The HKY rate matrix uses the `kappa` parameter to control relative rates of transitions (e.g. purine to purine, pyrimadine to pyrimadine) and transversions (purine to pyrimadine, pyrimadine to purine). The `pi_mol` parameter controls the stationary frequencies across nucleotides for the model. The prior mean on `kappa` is 1 and the prior mean on `pi_mol` is a flat Dirichlet distribution. Read more about the HKY matrix here {% cite Hasegawa85 %}.

```
for (i in 1:num_loci) {
    kappa[i] ~ dnGamma(2,2)
    moves.append(mvScale(kappa[i], weight=3))
    
    pi_mol[i] ~ dnDirichlet( [1,1,1,1] )
    moves.append(mvSimplex(pi_mol[i], alpha=3, offset=0.5, weight=3))
    
    Q_mol[i] := fnHKY(kappa=kappa[i], baseFrequencies=pi_mol[i])
}
```

Molecular rates variation among sites follow a Gamma distribution, approximated with four discrete rate classes. When `alpha` is large, all classes have relative rate factors of 1. When `alpha` is small, most rate classes are near 0 and one rate class is far greater than 1. Read more about the +Gamma among site rate variation model here {% cite Yang1994 %}.

```
for (i in 1:num_loci) {
    alpha[i] ~ dnExp(0.1)
    moves.append(mvScale(alpha[i], weight=3))
    
    site_rates[i] := fnDiscretizeGamma(shape=alpha[i],
                                       rate=alpha[i],
                                       numCats=4)
}
```

Now we have all the model components we need to define a partitioned molecular substitution model. This is called the phylogenetic continuous-time Markov chain (or phyloCTMC) in RevBayes. The `dnPhyloCTMC` models patterns of nucleotide variation under the evolutionary model for a given phylogenetic tree. 

We create one `dnPhyloCTMC` model for each locus. Each locus evolves along the branches of `timetree`, the phylogeny whose divergence times we wish to estimate.

```
for (i in 1:num_loci) {
    x_mol[i] ~ dnPhyloCTMC(
        Q=Q_mol[i],
        tree=timetree,
        branchRates=mu_mol[i],
        siteRates=site_rates[i],
        rootFrequencies=pi_mol[i],
        nSites=num_sites[i],
        type="DNA" )
}
```

We clamp the observed sequence alignment for each locus to the corresponding partitioned model component.

```
for (i in 1:num_loci) {
    x_mol[i].clamp(dat_mol[i])
}
```

We also apply special joint moves for updating the tree and molecular rates simultaneously. These moves are designed to take advantage of the fact that rate and time are not separately identifiable. That is, the likelihood remains unchanged if you multiply rates by 2 and divide times by 2. In short, these moves improve the performance of MCMC mixing.

```
# scales time (up) opposite of rate (down)
up_down_scale_tree = mvUpDownScale(lambda=1.0, weight=20)
up_down_scale_tree.addVariable(timetree,       up=true)
up_down_scale_tree.addVariable(root_age,       up=true)
up_down_scale_tree.addVariable(mu_mol_branch,  up=false)
up_down_scale_tree.addVariable(mu_mol_base,    up=false)
moves.append(up_down_scale_tree)

# scales base (up) and branch (up) rates
up_down_mol_rate = mvUpDownScale(lambda=1.0, weight=20)
up_down_mol_rate.addVariable(mu_mol_branch,  up=true)
up_down_mol_rate.addVariable(mu_mol_base,    up=true)
moves.append(up_down_mol_rate)

# redistributes rate and time to explain branch distance
rate_age_proposal = mvRateAgeProposal(timetree, weight=20, alpha=5)
rate_age_proposal.addRates(mu_mol_branch)
moves.append(rate_age_proposal)
```

Next, we construct monitors to capture information from our MCMC as it searches parameter space.

```
# screen monitor, so you don't get bored
monitors.append( mnScreen(root_age, printgen=print_gen) )

# file monitor for all simple model variables
monitors.append( mnModel(printgen=print_gen, file=out_fn+".model.txt") )

# file monitor for tree
monitors.append( mnFile(timetree, printgen=print_gen, file=out_fn + ".tre") )
```

Now that our model, moves, and monitors are properly configured, we can run MCMC.

```
# create model object
mymodel = model(timetree)

# create MCMC object
mymcmc = mcmc(mymodel, moves, monitors)

# run MCMC
mymcmc.run(n_iter)
```

Notice that we cannot estimate node ages with any precision.




{% section Biogeographic dating with node calibration %}


Repeat as earlier. Add a root age calibration. This is known as a secondary node age calibration, derived from a previous analysis. In this case, an earlier fossil-based node age estimate for the divergence of Hawaiian from non-Hawaiian Kadua lineages is used to constrain the `root_age` variable in our analysis.

We stored this information in a csv file called dat_calib. This the 95% highest posterior density age estimate for the most recent common ancestor of XX and XX. We define a truncated normal distribution with min and max ages following the 95 HPD, centered on the previous mean age estimate. Standard deviation is selected to induce a prior root age estimate that is wider than the original prior.

```
# get calibration data
dat_calib = readDataDelimitedFile(file=calib_fn, header=true, separator=",", rownames=false)
```

Go to phylo_BDP.Rev. Change root age.

```
# comment out the uniform prior on root age!
# root_age ~ dnUniform(0.0, 32.0)
    
# apply a secondary calibration to root age
mean_age <- dat_calib[1][2]
min_age <- dat_calib[1][3]
max_age <- dat_calib[1][4]
sd_age <- abs(max_age - min_age) / 4    # convert from 4 sd -> 1 sd
root_age ~ dnNormal(mean=mean_age,
                    sd=2*sd_age,
                    min=min_age,
                    max=max_age)

```


Scroll down, add this internal node age calibration.

```
# add ingroup calibration here!
age_bg_min <- 0.0
age_bg_max <- 6.3
clade_calib ~ dnUniform(age_bg_min-age_ingroup, age_bg_max-age_ingroup)
clade_calib.clamp(0.0)
```

Run again. Notice the difference in node age estimates. The prior imposes a hard bound on the maximum age of Hawaiian Kadua.


{% section Biogeographic dating with TimeFIG %}

Now we do the full TimeFIG analysis for biogeographic dating. Because we already ran a TimeFIG analysis on a fixed tree in the previous tutorial, this tutorial will instead demonstrate how to convert the fixed-tree TimeFIG analysis to treat the tree as a random variable. Broadly speaking, we'll apply what we learned about molecular phylogenetics in the first part of this tutorial in combination with what we learned from the previous fixed-tree TimeFIG analysis. Let's get started!



```

###########################
# LOAD TENSORPHYLO PLUGIN #
###########################

tensorphylo_fp = "/Users/mlandis/.local/lib/tensorphylo"
if (!exists("tensorphylo_fp")) {
  tensorphylo_fp = "~/.plugins/"
}
loadPlugin("TensorPhylo", tensorphylo_fp)

#######################
# INITIALIZE SETTINGS #
#######################

# analysis string name
analysis                                    = "timeFIG_dating"

print("Analysis name: ", analysis)


# analysis settings
n_proc          = 6
n_iter          = 10000
print_gen       = 1
stoch_print_gen = 20

``` 


```


# filesystem
clade_name    = "kadua"
fp            = "./"
dat_fp        = fp + "data/clade/"
geo_fp        = fp + "data/geo/"
mol_fp        = dat_fp + "/genes/"
code_fp       = fp + "scripts/timefig_dating/"
feature_fn    = geo_fp + "feature_summary.csv"
calib_fn      = dat_fp + clade_name + "_calib.csv"
phy_fn        = dat_fp + clade_name + ".tre"
bg_fn         = dat_fp + clade_name + "_range.nex"
label_fn      = dat_fp + clade_name + "_range_label.csv"

# model source code
geo_code_fn   = code_fp + "geo_timeFIG.Rev"
mol_code_fn   = code_fp + "mol_timeFIG.Rev"
phylo_code_fn = code_fp + "phylo_timeFIG.Rev"
clade_fn      = code_fp + "clade.Rev"

``` 

```


# get phylogenetic data
phy          <- readTrees(phy_fn)[1]
phy.rescale( 5./phy.rootAge() )
tree_height  <- phy.rootAge()
taxa         = phy.taxa()
num_taxa     = taxa.size()
num_branches = 2 * num_taxa - 2

# dataset constraints

if (!exists("max_subrange_split_size")) max_subrange_split_size = 7
if (!exists("max_range_size"))    max_range_size = 4


```

Range data


```
# get biogeographic data
dat_01       = readDiscreteCharacterData(bg_fn)
num_regions  = dat_01.nchar()
num_ranges   = 0
for (k in 1:max_range_size) {
    num_ranges += choose(num_regions, k)
}
dat_nn       = formatDiscreteCharacterData(dat_01, format="GeoSSE", numStates=num_ranges)
desc         = dat_nn.getStateDescriptions()

write("index,range\n", filename=label_fn)
for (i in 1:desc.size()) {
    write((i-1) + "," + desc[i] + "\n", filename=label_fn, append=true)
}

```

Same stuff as above for molecular model.

```
# get molecular data

num_loci = 10
for (i in 1:num_loci) {
    mol_fn[i] = mol_fp + "clean_" + mol_idx[i] + "_supercontig.nexus"
    dat_mol[i] = readDiscreteCharacterData(mol_fn[i])
    num_sites[i] = dat_mol[i].nchar()
}

```


Load clade info
```
# load ingroup clade info
source(clade_fn)
# get calibration data
if (use_root_calib) {
    dat_calib = readDataDelimitedFile(file=calib_fn, header=true, separator=",", rownames=false)
}
```

Load geography stuff. This is identical to TimeFIG tutorial. Go back to that tutorial if you've forgotten what it does.

```
# load geography model script
source( geo_code_fn )
```

Set up the phylogenetic model. Much of this is like the TimeFIG tutorial setup, but instead we treat aspects of the tree as a random variable.

```
# load phylogeny model script
source( phylo_code_fn )
# associate phylo/biogeo data with model
timetree.setValue(phy)
timetree.clampCharData(dat_nn)
```

Load the original molecular model and clamp data.

```
# load molecular model script

source( mol_code_fn )
for (i in 1:num_loci) {
    x_mol[i].clamp(dat_mol[i])
}
```

{% subsection Analysis %}

Set up moves.

```
# create moves
moves = VectorMoves()

# node age updates
moves.append( mvScale(root_age, weight=15) )
moves.append( mvNodeTimeSlideUniform(timetree, weight=2*num_taxa) )

``` 

Set up moves on base rates for TimeFIG.

```
moves.append( mvScale(rho_d, weight=5) )
moves.append( mvScale(rho_e, weight=5) )
moves.append( mvScale(rho_w, weight=5) )
moves.append( mvScale(rho_b, weight=5) )

```

Set up moves to update model parameters. We'll explain the first one in detail, then provide blocks of code that do the same thing for different sets of feature effect parameters.

```
for (i in 1:sigma_e.size()) {
  
    moves.append( mvScale(sigma_e[i], weight=2) )
    moves.append( mvSlide(sigma_e[i], weight=2) )
    moves.append( mvRJSwitch(sigma_e[i], weight=3) )
    use_sigma_e[i] := ifelse(sigma_e[i] == 0.0, 0, 1)
    
}
```


```
for (i in 1:sigma_w.size()) {
    moves.append( mvScale(sigma_w[i], weight=2) )
    moves.append( mvSlide(sigma_w[i], weight=2) )
    moves.append( mvRJSwitch(sigma_w[i], weight=3) )
    use_sigma_w[i] := ifelse(sigma_w[i] == 0.0, 0, 1)
}
```

```
for (i in 1:sigma_d.size()) {
    moves.append( mvScale(sigma_d[i], weight=2) )
    moves.append( mvSlide(sigma_d[i], weight=2) )
    moves.append( mvRJSwitch(sigma_d[i], weight=3) )
    use_sigma_d[i] := ifelse(sigma_d[i] == 0.0, 0, 1)
    
}

for (i in 1:sigma_b.size()) {
    moves.append( mvScale(sigma_b[i], weight=2) )
    moves.append( mvSlide(sigma_b[i], weight=2) )
    moves.append( mvRJSwitch(sigma_b[i], weight=3) )
    use_sigma_b[i] := ifelse(sigma_b[i] == 0.0, 0, 1)
}

for (i in 1:phi_e.size()) {
    moves.append( mvScale(phi_e[i], weight=2) )
    moves.append( mvScale(phi_w[i], weight=2) )
    moves.append( mvSlide(phi_e[i], weight=2) )
    moves.append( mvSlide(phi_w[i], weight=2) )
    if (use_rj) {
        moves.append( mvRJSwitch(phi_e[i], weight=3) )
        moves.append( mvRJSwitch(phi_w[i], weight=3) )
        use_phi_e[i] := ifelse(phi_e[i] == 0.0, 0, 1)
        use_phi_w[i] := ifelse(phi_w[i] == 0.0, 0, 1)
    }
}
for (i in 1:phi_d.size()) {
    moves.append( mvScale(phi_d[i], weight=2) )
    moves.append( mvScale(phi_b[i], weight=2) )
    moves.append( mvSlide(phi_d[i], weight=2) )
    moves.append( mvSlide(phi_b[i], weight=2) )
 if (use_rj) {
        moves.append( mvRJSwitch(phi_d[i], weight=3) )
        moves.append( mvRJSwitch(phi_b[i], weight=3) )
        use_phi_d[i] := ifelse(phi_d[i] == 0.0, 0, 1)
        use_phi_b[i] := ifelse(phi_b[i] == 0.0, 0, 1)
    }
}

```

```

# base rate of molecular substitutioni
moves.append(mvScale(mu_mol_base, weight=5) )

# branch rates of molecular substitution, centered on mu_mol_base
for (i in 1:num_branches) {
    moves.append(mvScale(mu_mol_branch[i], weight=1))
}

for (i in 1:num_loci) {
    if (i >= 2) {
        moves.append(mvScale(mu_mol_locus_rel[i], weight=3))
    }
    moves.append(mvScale(kappa[i], weight=3))
    moves.append(mvScale(alpha[i], weight=3))
    moves.append(mvSimplex(pi_mol[i], alpha=3, offset=0.5, weight=3))
}

# joint moves
up_down_scale_tree = mvUpDownScale(lambda=1.0, weight=20)
up_down_scale_tree.addVariable(timetree,      up=true)
up_down_scale_tree.addVariable(root_age,      up=true)
up_down_scale_tree.addVariable(mu_mol_branch, up=false)
up_down_scale_tree.addVariable(mu_mol_base,   up=false)
moves.append(up_down_scale_tree)

up_down_mol_rate = mvUpDownScale(lambda=1.0, weight=20)
up_down_mol_rate.addVariable(mu_mol_branch, up=true)
up_down_mol_rate.addVariable(mu_mol_base,   up=true)
moves.append(up_down_mol_rate)

# MJL: this seems to cause a bug, working to fix w/ Mike May
rate_age_proposal = mvRateAgeProposal(timetree, weight=20, alpha=5)
rate_age_proposal.addRates(mu_mol_branch)
moves.append(rate_age_proposal)
```



```
############
# Monitors #
############

print("Creating monitors...")
# create monitor vector
monitors = VectorMonitors()
# screen monitor, so you don't get bored
monitors.append( mnScreen(root_age, printgen=print_gen) )
# file monitor for all simple model variables
monitors.append( mnModel(printgen=print_gen, file="output/" + analysis + ".model.txt") )
# file monitor for tree
monitors.append( mnFile(timetree, printgen=print_gen, file="output/" + analysis + ".tre") )

```

Get biogeographic rates across time slices

```

# file monitor for biogeographic model
for (k in 1:num_times) {
    bg_mon_filename = "output/" + analysis + ".time" + k + ".bg.txt"
    monitors.append( mnFile(filename = bg_mon_filename,printgen=print_gen,rho_e, rho_w, rho_d, rho_b, r_e[k], r_w[k], r_d[k][1], r_d[k][2], r_d[k][3], r_d[k][4], r_d[k][5], r_d[k][6], r_b[k][1], r_b[k][2], r_b[k][3], r_b[k][4], r_b[k][5], r_b[k][6], m_e[k][1], m_w[k][1], m_d[k][1], m_d[k][2], m_d[k][3], m_d[k][4], m_d[k][5], m_d[k][6], m_b[k][1], m_b[k][2], m_b[k][3], m_b[k][4], m_b[k][5], m_b[k][6]))
}
```


```
monitors.append( mnFile(filename="output/"+analysis+".param.json", printgen=print_gen, format="json",
                        rho_e, rho_w, rho_d, rho_b, r_e, r_w, r_d, r_b, m_e, m_w, m_d, m_b) )
```


Get ancestral states

```
# ancestral estimates
monitors.append( mnJointConditionalAncestralState(tree=timetree, glhbdsp=timetree, printgen=print_gen*stoch_print_gen, filename="output/" + analysis + ".states.txt", withTips=true, withStartStates=true, type="NaturalNumbers") )
```

Stochastic mapping

```
# monitors.append( mnStochasticCharacterMap(glhbdsp=timetree, printgen=print_gen*10, filename="output/" + analysis + ".stoch.txt", use_simmap_default=false) )

```

Run model

```
# create model object
print("Creating model...")
mymodel = model(timetree)

# create MCMC object
print("Creating MCMC...")
mymcmc = mcmc(mymodel, moves, monitors, moveschedule=move_schedule)
mymcmc.operatorSummary()

# run MCMC
print("Running MCMC...")
mymcmc.run(n_iter, underPrior=under_prior)

# done!
quit()
```

Look at these figures. Let's compare across analyses.