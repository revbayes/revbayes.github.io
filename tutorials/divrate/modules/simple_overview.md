{% section Overview: Diversification Rate Estimation | diversification_rate_overview %}


Stochastic branching models allow for inference of speciation and
extinction rates. In these tutorials we focus on the different types of macroevolutionary
models to study diversification processes and thus the
diversification-rate parameters themselves. 


{% subsection Types of Hypotheses for Estimating Diversification Rates %}

Macroevolutionary diversification rate estimation focuses on different key hypothesis,
which may include:
adaptive radiation, diversity-dependent and character diversification, key innovations, and
mass extinction. 
We classify these hypotheses primarily into questions whether diversification rates vary through time, 
and if so, whether some external, global factor has driven diversification rate changes, or if
diversification rates vary among lineages, and if so, whether some species specific factor is correlated with
the diversification rates.

Below, we describe each of the fundamental questions regarding diversification rates.

{% subsubsection (1) Constant diversification-rate estimation %}

*What is the global rate of diversification in my phylogeny?* 
The most basic models estimate parameters of the birth-death process 
(*i.e.*, rates of speciation and extinction, or composite parameters 
such as net-diversification and relative-extinction rates) 
under the assumption that rates have remained constant across lineages and through time.
This is the most basic example and should be treated as a primer and introduction into the topic.

For more information, we recommend the {% page_ref divrate/simple %}.


{% subsubsection (2) Diversification rate variation through time %}

*Is there diversification rate variation through time in my phylogeny?*
There are several reasons why diversification rates for the entire study group can vary through time, for example:
adaptive radiation, diversity dependence and mass-extinction events.
We can detect a signal any of these causes by detecting diversification rate variation through time.

The different tutorials references below cover different scenarios for diversification rate variation through time.
The common theme of these studies is that the diversification process is tree-wide, that is, 
all lineages of the study group have the exact same rates at a given time.


{% subsubsection (2a) Detecting diversification rate variation through time %}

In 'RevBayes' we use an episodic birth-death model to study diversification rate variation through time.
That is, we assume that diversification rates are constant within an epoch but may shift between episodes ({% citet Stadler2011 Hoehna2015a %}). 
Then, we are estimating the diversification rates for each episode, and thus diversification rate variation through time.

You can find examples and more information in the {% page_ref divrate/ebd %}.


{% subsubsection (2b) Detecting the impact of mass-extinction events on diversification %}

Another question in this category asks whether our study tree was impacted by a mass-extinction event 
(where a large fraction of the standing species diversity is suddenly lost, e.g., {% citet Hoehna2015a May2016 %}). 



{% subsubsection (2c) Diversification-rate correlation to environmental (e.g., abiotic) factors %}

*Are diversification rates correlated with some abiotic (e.g., environmental) variable in my phylogeny?*
If we have found evidence in the previous section that diversification rates vary through time, 
then we can start asking the question whether these changes in diversification
rates are driven by some abiotic (e.g., environmental) factors. 
For example, we can ask whether changes in diversification rates are correlated with
environmental factors, such as environmental CO<sub>2</sub> or temperature {% cite Condamine2013 Condamine2018 %}. 

You can find examples and more information in the {% page_ref divrate/env %}.


{% subsubsection (3) Diversification-rate variation across branches estimation %}
*Is there evidence that diversification rates have varied across the branches of my phylogeny?* 
Have there been significant diversification-rate shifts along branches in my phylogeny, 
and if so, how many shifts, what magnitude of rate-shifts and along which branches?
Similarly, one may ask what are the branch-specific diversification rates?

You can study diversification rate variation among lineages using our birth-death-shift process {% cite Hoehna2019 %}. 
Examples and more information is provided in the {% page_ref divrate/branch_specific %}.


{% subsubsection (4) Character-dependent diversification-rate estimation %}
If we have found that there is rate variation among lineage, then we could ask if 
diversification rates correlated with some biotic (e.g., morphological) variable.
This can be addressed by using character-dependent birth-death models 
(often also called state-dependent speciation and extinction models; SSE models).
Character-dependent diversification-rate models aim to identify
overall correlations between diversification rates and organismal
features (binary and multi-state discrete morphological traits,
continuous morphological traits, geographic range, etc.). For example,
one can hypothesize that a binary character, say if an organism is
herbivorous/carnivorous or self-compatible/self-incompatible, impact the
diversification rates. Then, if the organism is in state 0 (e.g., is herbivorous) 
it has a lower (or higher) diversification rate than if the organism is in state 1 (e.g., carnivorous) {% cite Maddison2007 %}.

You can find examples and more information in the {% page_ref sse/bisse-intro %}.
