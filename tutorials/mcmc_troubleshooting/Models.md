{% assign models_script = "models.Rev" %}

{% section Models %}

If there are still convergence problems after the inference setup, priors, and starting values have been checked, we have to consider whether the model is appropriate for our data. There are steps to ensure this that can be taken during setup already, but also tests and modifications that can be used afterwards, as detailed below.


{% subsection Helpful Tools %}

It can seem hard at first to decide on appropriate models or model components, especially if it seems unclear what to base such decisions on. Luckily there exist a number of tools that can be used to make more informed decisions.

- **jModelTest**: Standalone software that tests for best-fitting nucleotide substitution models [(GitHub)](https://github.com/ddarriba/jmodeltest2/).
- **PartitionFinder**: Standalone software that tests for best-fitting partitioning schemes and molecular evolution models [(Website)](https://www.robertlanfear.com/partitionfinder/).
- **ClockstaR**: R package that tests for appropriate relaxed clocks for molecular data [(GitHub)](https://github.com/sebastianduchene/ClockstaR).
- **EvoPhylo**: R package that tests for partitioning schemes for clock models for morphological data [(CRAN)](https://cran.r-project.org/package=EvoPhylo).
- **PBDB tools**: Lists various [resources](https://paleobiodb.org/#/resources) to help with assembling and processing fossil data, calculating diversification and sampling parameters, and other useful functions.


{% subsection Separating Joint Inferences %}

When running inferences of different parameters jointly, e.g., when using different data types in the same analysis, or inferring topologies jointly with node ages, convergence issues can arise if those different inference parts are supporting different solutions. For example, if molecular and morphological data suggests different tree topologies. If the supported topologies differe too much, the joint model will be torn between them, being unable to converge (as each data source lowers the likelihood of the result the other one supports and vice versa). Similar issues can be cuased if e.g., different partitions strongly support different topologies.
{{ models_script | snippet:"block#","1" }}


{% subsection Model Assumptions and Adequacy %}

Besides aforementioned conflicts, the model may also be much more fundamentally unsuitable for the data. It mighth thus be necessary to revisit the assumptions of the model and check whether the data meets those assumptions. Are sample sizes sufficient? Is variation distributed as expected? Are numbers of trait states/nucleotides severely skewed?

Especially for models with many parts, the assumptions and their interactiosn can be difficult to judge. In such a case (but also in general), an option is to use model adequacy tests, which were specifically designed to find data-model-mismatches. Many use posterior predictive simulations (PPS), an approach which simulates data under the model (using the parameters inferred from the data) to simulate new datasets. The characteristics of these are then compared to those of the initial data, and if they differ significantly, that implies that the model is inadequate to describe the data.

The concept of that approach is rather straightforward, and any model or analysis combining multiple models can be tested this way, as long as both inference and simulation are possible with the same model. However, the main difficulties lie in having sets of summary statistics which capture the relevant characteristics in which the model and the data need to match, and to interpret what particular data-model-mismatches the discrepant summary statistics translate into. Also, it should be noted that this approach can only be used if an MCMC chain can be run (to have a posterior to sample from to simulate new data sets), and not if it fails to run to begin with.

PPS approaches have been developed for various kinds of phylogenetic models already, many of which could be used in RevBayes. The tutorial [Introduction to Posterior Prediction](https://revbayes.github.io/tutorials/intro_posterior_prediction/) demonstrates the concept and neccessary Rev code in more detail, while three associated tutorials exemplify the use of posterior prediction to test tree inference models using the P$^3$ approach.


{% subsection Reducing Complexity %}

At last, we might have to consider reducing the complexity of our model. While modern approaches allow us to incorporate all kinds of processes and interactions, and to consider all kinds of patterns, such complex models will only work well if the data contains enough signal to inform this complexity. Similar to any statistical test requiring sufficient sample size to produce meaningful results, these models require certain structure and heterogeneity in the data to be able to infer parameters without too much uncertainty.

For example, if we use a relaxed clock model (allowing for different rates of evolution along different branches) but only have one fossil node calibration or not much sequence variation, the MCMC may struggle to find much support for a particular configuration of branch rates. Since there is no information in the data to back up higher or lower rates in different parts of the tree the MCMC will find roughly similar support for many rate combinations, leading to estimates with large uncertainty - and in the process will take a long time to converge too. If we simplify the model by using a strict clock, we may instead converge on overall sensible rates within a reasonable time, despite missing out on some rate heterogeneity.

Similarly, if we divide our sequence data into many partitions despite noth much evidence for different rate dynamics, we are thereby decreasing the sample size within each partition, perhaps making it harder to get confident rate inferences from each one than if we had concatenated some of the partitons instead.


Our inferences can only provide answers as detailed and nuanced as our data can inform, meaning we have to adjust our modelling ambitions accordingly (or fill any gaps in our data).

