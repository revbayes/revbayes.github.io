---
title: Biogeographic dating using the TimeFIG model
subtitle: Using the TimeFIG model to jointly infer divergence times and biogeographic history
authors:  Michael Landis, Sarah Swiston, Isaac Lichter Marck, Fabio Mendes, Felipe Zapata
level: 8
order: 11
prerequisites:
  - fig/clocks
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

{% section Background on molecular dating %}

Genetic data are critical to estimate phylogenetic relationships among living species. In general, genetic content is more similar among closely related species, and less similar among more highly divergent species. As mutations accumulate within a genome that is inherited across generations over time, the distances in genetic similarity will increase as phylogenetic lineages increasingly diverge over time.

Molecular phylogenetic models use these estimates of genetic distance to infer phylogenetic divergence, in terms of topology (relationships among lineages) and branch lengths (distances along lineages). Phylogenetic models often measure genetic distances in units of *expected substitutions per site*. These distances are, in fact, the product of time (e.g. millions of years) and the substitution rate (substitutions per site per time). This substitution rate is often called the *molecular clock* {% cite Zuckerkandl1967 %}. An accurate estimate of such a clock rate would enable *molecular dating*, because a research would only need to convert molecular distances into clock "ticks" to estimate the ages of species in units of geological time. 

Ideally, a molecular phylogenetic model would be able to decompose estimates of molecular distance into separate estimates of substitution rates and evolutionary time. Unfortunately, standard phylogenetic methods cannot do this intrinsically. In real biological settings, we never know the precise time or rate underlying a molecular distance, so we must somehow model the uncertainty in these parameters. 

In practice, biologists use extrinsic evidence to "calibrate" the molecular clock to a geological timescale. Fossil evidence can be used to constrain the minimum age of a phylogenetic divergence event (e.g. a child species cannot be older than its parent species), which effectively constrains time and, indirectly, rate estimates. Two main approaches have been used to deploy fossil-based calibrations. Prior-based calibrations assign a node age distribution to internal nodes on a phylogeny, selected and specified using expert knowledge. Process-based calibrations explicitly incorporate fossil morphology and ages as data during phylogenetic inference to assign ages to clades. Read these excellent papers to read more about fossil-based dating. 

Paleogeography provides a complementary source of information to estimate divergence times through *biogeographic dating*. Biogeographic dating is often used for studying clades that possess no useful fossils (e.g. clades of island plants, like *Kadua*). The logic for biogeographic dating is as follows: imagine a clade of ten species that are endemic to a volcanic island that is less than one million years old. If it is assumed a single lineage colonized the island after it emerged, then the maximum age of the clade must be younger than the island, allowing the biologist to calibrate the molecular clock.

Biogeographic dating has typically relied on prior-based constraints, requiring that the biologist makes strong assumptions about many unknowable factors: the timing and effect of paleogeographic events the dispersal abilities of species, relationships among species, and more. In addition, using a biogeographic hypothesis to date a clade (e.g. "we assume the islands were colonized after they originate") means that dated phylogeny cannot be safely used to test downstream biogeography hypotheses ("when were the islands first colonized by the clade?"). Doing so would be circular.

This tutorial describes how to perform a process-based biogeographic dating analysis using the TimeFIG model. The process-based approach uses paleogeographically-informed biogeographic rates to extract information about divergence times through a dataset, rather than constraining estimates using a user-designed node age prior. Previous approaches for process-based biogeographic dating relied on simpler models that did not consider how speciation and extinction rates vary among regions over time. TimeFIG models this important relationship between paleogeographically-varying features, species ranges, biogeographic rates, and divergence times.

The rest of the tutorial explores biogeographic dating analysis. We'll start with a simple molecular phylogenetic analysis *without* time calibration. Then, we'll repeat the analysis using a prior-based biogeographic node age calibration. Lastly, we'll perform a process-based TimeFIG analyses to estimate divergence times. Because these analyses build on each other, we only introduce what *changes* for each new analysis.

This tutorial is also bundled with RevBayes scripts that complete analyses equivalent to those written below. However, the scripts are often designed to be more modular and general, making them ideal to customize for analyses of new datasets, other than Hawaiian Kadua.


{% subsection Molecular phylogenetics %}

First, we'll run a simple molecular phylogenetic analysis *without* any information to time-calibrate the tree. The tutorial reviews several important concepts for phylogenetic tree estimation, such as the relaxed molecular clock. It also demonstrates that extrinsic (non-molecular) evidence is needed to time-calibrate divergence times using standard phylogenetic approaches.

Let's get started! First set up filesystem variables.

```
# filesystem
analysis      = "BDP_dating"
dat_fp        = "./data/kadua/"
phy_fn        = dat_fp + "kadua.tre"
calib_fn      = dat_fp + "kadua_calib.csv"
out_fn        = "./output/" + analysis

# model source code
mol_code_fn   = "./scripts/timefig_dating/mol_timeFIG.Rev"
phylo_code_fn = "./scripts/timefig_dating/phylo_BDP.Rev"
clade_fn      = "./scripts/timefig_dating/clade.Rev"

```

Make the tree
```
# get phylogenetic data
phy          <- readTrees(phy_fn)[1]
phy.rescale( 5./phy.rootAge() )
tree_height  <- phy.rootAge()
taxa         = phy.taxa()
num_taxa     = taxa.size()
num_branches = 2 * num_taxa - 2
```

Read molecular data, handle missing taxa

```
# get molecular data
num_loci     = 10
for (i in 1:num_loci) {
    mol_fn[i] = dat_fp + "genes/kadua_" + mol_idx[i] + "_supercontig.nex"
    dat_mol[i] = readDiscreteCharacterData(mol_fn[i])
    num_sites[i] = dat_mol[i].nchar()
}

### hopefully we don't need this junk

#subset the molecular alignments to match the taxa in the tree
# get the names of taxa on the tree
for(i in 1:taxa.size()) {
    taxa_names[i] = taxa[i].getName()
}

for(i in 1:num_loci) {
    # first, exclude all taxa
    dat_mol[i].excludeTaxa(dat_mol[i].taxa())
    
    # now, include taxa from tree
    dat_mol[i].includeTaxa(taxa_names)

    # make sure we include missing data (add taxa that are missing in the alignment but appear in the tree)    
    dat_mol[i].addMissingTaxa(taxa_names)
}

```


Load the contents of the file `clade.Rev`. This code defines several Kadua clades so that we can easily track their ages.

```
# load ingroup clade info
source(clade_fn)
```


Next, we will manually configure the birth-death model by entering commands. Once you feel comfortable with this exercise, you can instead load the model definition using the `source()` function.
```
# load phylogeny model script
source( phylo_code_fn )
```


Set up birth and death rates for birth-death process. We assign priors to the net diversification rate (birth - death) and turnover proportion (ratio of death to birth events). Net diversification rate controls how rapidly species accumuluation, whereas turnover proportion controls the speed of extinction relative to speciation. This parameterization often behaves better for model fitting, and many biologists prefer to think in these terms. 

```
# base rate parameters
diversification ~ dnExp(1)
turnover ~ dnBeta(2,2)
birth := diversification / abs(1.0 - turnover)
death := birth * turnover

```

We have most, but not all, taxa. Tell model about missing taxa.

```
# tip state sampling probabilities
# assume that ranges with ingroup regions (RKOMH) are perfectly
# sampled, while the outgroup region (Z) has very low sampling

# see ref Lorence 2010
n_total <- 32
n_sample <- 27
rho <- n_sample / n_total
```


Set up root age prior. Note, we will modify this in the next section.

```
root_age ~ dnUniform(0.0, 32.0)
root_age.setValue(tree_height)
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


```

Collect info about node ages

```
#####################
# Node age monitors #
#####################

age_ingroup := tmrca(timetree, clade_ingroup)
age_affinis := tmrca(timetree, clade_affinis)
age_centrantoides := tmrca(timetree, clade_centrantoides)
age_flynni := tmrca(timetree, clade_flynni)
age_littoralis := tmrca(timetree, clade_littoralis)
age_littoralis_flynni := tmrca(timetree, clade_littoralis_flynni)

```

Set an initial tree
```
# associate phylo/biogeo data with model
timetree.setValue(phy)
```

Now we have a variable representing our phylogeny. Next, we'll model how molecular variation accumulates over time. For this, we will use a partitioned substitution model with a relaxed molecular clock. This means rates of molecular evolution can vary among branches, among loci, and among sites.

First, we create the relaxed clock model. This creates a uncorrelated lognormal relaxed molecular clock that allows for rates to vary among branches.

```
# base substitution rate
mu_mol_base ~ dnExp(10)
mu_mol_sd <- 0.587405

# relative among branch rate variation
# mu_mol_branch_rel ~ dnDirichlet(rep(2, num_branches))
for (i in 1:num_branches) {
    ln_mean := ln(mu_mol_base) - 0.5 * mu_mol_sd * mu_mol_sd
    mu_mol_branch[i] ~ dnLnorm(ln_mean, mu_mol_sd)
}
```

Our analysis has many loci. We will construct what's known as a partitioned analysis. In a partition analysis, each locus may have its own evolutionary rates. We will assign each locus its own rate scaling factor, rate matrix, and site-rate variation parameters. 

This code allows substitution rates to vary among loci, with the mean rate of 1. 

```
for (i in 1:num_loci) {

    if (i == 1) {
        mu_mol_locus_rel[i] <- 1.0
    } else {
        mu_mol_locus_rel[i] ~ dnGamma(2,2)
    }
    # relaxed clock across branch-locus rate combinations
    mu_mol[i] := mu_mol_locus_rel[i] * mu_mol_branch
}
```

Next, we specify the HKY rate matrix to define transition rates among nucleotides. The HKY rate matrix uses the `kappa` parameter to control relative rates of transitions (e.g. purine to purine, pyrimadine to pyrimadine) and transversions (purine to pyrimadine, pyrimadine to purine). The `pi` parameter controls the stationary frequencies across nucleotides for the model. Read more about the HKY matrix here {% cite Hasegawa85 %}.

```
for (i in 1:num_loci) {
    kappa[i] ~ dnGamma(2,2)
    pi_mol[i] ~ dnDirichlet( [1,1,1,1] )
    Q_mol[i] := fnHKY(kappa=kappa[i], baseFrequencies=pi_mol[i])
}
```

We then allow molecular rates variation among sites to follow a Gamma distribution, approximated with four rate classes. Read more about the the +Gamma among site rate variation model here {% Yang1994 %}.

```
for (i in 1:num_loci) {
    alpha[i] ~ dnExp(0.1) # expected value 1/0.1 == 10
    site_rates[i] := fnDiscretizeGamma(shape=alpha[i], rate=alpha[i], numCats=4, median=true)
}
```

Now we have all the model components we need to define a molecular substitution model. This is called the phylogenetic continuous-time Markov chain (or phyloCTMC) in RevBayes. The `dnPhyloCTMC` models patterns of nucleotide variation under the evolutionary model for a given phylogenetic tree. 

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



Clamp molecular data
```
# load molecular model script
source( mol_code_fn )
for (i in 1:num_loci) {
    x_mol[i].clamp(dat_mol[i])
}
```


Set up tree moves
```
# create moves
moves = VectorMoves()

# tree variable moves
moves.append( mvNodeTimeSlideUniform(timetree, weight=2*num_taxa) )
moves.append( mvScale(root_age, weight=15) )
```

Set up molecular moves

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
```

We also apply joint moves for updating the tree and molecular rates simultaneously. These take advantage of the fact that rate and time are not separately identifiable. That is, the likelihood remains unchanged if you multiply rates by 2 and divide times by 2.

```
# joint moves
up_down_scale_tree = mvUpDownScale(lambda=1.0, weight=20)
up_down_scale_tree.addVariable(timetree,       up=true)
up_down_scale_tree.addVariable(root_age,       up=true)
up_down_scale_tree.addVariable(mu_mol_branch,  up=false)
up_down_scale_tree.addVariable(mu_mol_base,    up=false)
moves.append(up_down_scale_tree)

up_down_mol_rate = mvUpDownScale(lambda=1.0, weight=20)
up_down_mol_rate.addVariable(mu_mol_branch,  up=true)
up_down_mol_rate.addVariable(mu_mol_base,    up=true)
moves.append(up_down_mol_rate)

rate_age_proposal = mvRateAgeProposal(timetree, weight=20, alpha=5)
rate_age_proposal.addRates(mu_mol_branch)
moves.append(rate_age_proposal)
```

Next, we want to capture information from our MCMC. We define Monitors to do this.


```
# create monitor vector
monitors = VectorMonitors()

# screen monitor, so you don't get bored
monitors.append( mnScreen(root_age, printgen=print_gen) )

# file monitor for all simple model variables
monitors.append( mnModel(printgen=print_gen, file=out_fn+".model.txt") )

# file monitor for tree
monitors.append( mnFile(timetree, printgen=print_gen, file=out_fn + ".tre") )
```

Setting up model, chain, run it.

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

Notice that we cannot estimate node ages with any precision.




{% subsection Biogeographic dating with node calibration %}


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


{% subsection Biogeographic dating with TimeFIG %}

Now we do the full TimeFIG analysis for biogeographic dating. Because we already ran a TimeFIG analysis on a fixed tree in the previous tutorial, this tutorial will instead demonstrate how to convert the fixed-tree TimeFIG analysis to treat the tree as a random variable. Broadly speaking, we'll apply what we learned about molecular phylogenetics in the first part of this tutorial in combination with what we learned from the previous fixed-tree TimeFIG analysis. Let's get started!



