{% section Diversification Rate Models | models %}


We begin this section with a general introduction to the stochastic
birth-death branching process that underlies inference of
diversification rates in RevBayes. This primer will
provide some details on the relevant theory of stochastic-branching
process models. We appreciate that some readers may want to skip this
somewhat technical primer; however, we believe that a better
understanding of the relevant theory provides a foundation for
performing better inferences. We then discuss a variety of specific
birth-death models, but emphasize that these examples represent only a
tiny fraction of the possible diversification-rate models that can be
specified in RevBayes.

{% subsection The birth-death branching process %}


{% figure fig_birth_death_shift %}
<img src="figures/BirthDeathShift.png" width="50%" height="50%" /> 
{% figcaption %} 
A realization of the birth-death process with mass extinction. 
Lineages that have no extant or sampled descendant are shown in gray and
surviving lineages are shown in a thicker black line.
{% endfigcaption %}
{% endfigure %}

Our approach is based on the *reconstructed evolutionary process*
described by {% cite Nee1994b %}; a birth-death process in which only sampled,
extant lineages are observed. Let $N(t)$ denote the number of species at
time $t$. Assume the process starts at time $t_1$ (the 'crown' age of
the most recent common ancestor of the study group, $t_\text{MRCA}$)
when there are two species. Thus, the process is initiated with two
species, $N(t_1) = 2$. We condition the process on sampling at least one
descendant from each of these initial two lineages; otherwise $t_1$
would not correspond to the $t_\text{MRCA}$ of our study group. Each
lineage evolves independently of all other lineages, giving rise to
exactly one new lineage with rate $b(t)$ and losing one existing lineage
with rate $d(t)$ ({% ref fig_birth_death_shift %} and
{% ref fig_bdp %}). Note that although each lineage evolves
independently, all lineages share both a common (tree-wide) speciation
rate $b(t)$ and a common extinction rate $d(t)$
{% cite Nee1994b Hoehna2015a %}. Additionally, at certain times,
$t_{\mathbb{M}}$, a mass-extinction event occurs and each species
existing at that time has the same probability, $\rho$, of survival.
Finally, all extinct lineages are pruned and only the reconstructed tree
remains ({% ref fig_birth_death_shift %}).

{% figure fig_bdp %}
<img src="figures/birth-death-sketch.png" width="75%" height="75%" /> 
{% figcaption %} 
**Examples of trees produced under a birth-death process.** 
The process is initiated at the first speciation event (the 'crown-age' of the MRCA)
when there are two initial lineages. At each speciation event the ancestral lineage is replaced by two
descendant lineages. At an extinction event one lineage simply
terminates. (A) A complete tree including extinct lineages. (B) The
reconstructed tree of tree from A with extinct lineages pruned away. (C)
A *uniform* subsample of the tree from B, where each species was sampled
with equal probability, $\rho$. (D) A *diversified* subsample of the
tree from B, where the species were selected so as to maximize diversity.
{% endfigcaption %}
{% endfigure %}

To condition the probability of observing the branching times on the
survival of both lineages that descend from the root, we divide by
$P(N(T) > 0 | N(0) = 1)^2$. Then, the probability density of the
branching times, $\mathbb{T}$, becomes 

$$\begin{aligned}
P(\mathbb{T}) = \frac{\overbrace{P(N(T) = 1 \mid N(0) = 1)^2}^{\text{both initial lineages have one descendant}}}{ \underbrace{P(N(T) > 0 \mid N(0) = 1)^2}_{\text{both initial lineages survive}} } \times \prod_{i=2}^{n-1} \overbrace{i \times b(t_i)}^{\text{speciation rate}} \times \overbrace{P(N(T) = 1 \mid N(t_i) = 1)}^\text{lineage has one descendant},
\end{aligned}$$

and the probability density of the reconstructed tree (topology and branching times) is then 

$$\begin{aligned}
P(\Psi) = \; & \frac{2^{n-1}}{n!(n-1)!} \times \left( \frac{P(N(T) = 1 \mid N(0) = 1)}{P(N(T) > 0 \mid N(0) = 1)} \right)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} i \times b(t_i) \times P(N(T) = 1 \mid N(t_i) = 1)
		  \label{eq:tree_probability}
\end{aligned}$$

We can expand Equation ([eq:tree_probability]) by substituting
$P(N(T) > 0 \mid N(t) =1)^2 \exp(r(t,T))$ for
$P(N(T) = 1 \mid N(t) = 1)$, where $r(u,v) = \int^v_u d(t)-b(t)dt$; the
above equation becomes 

$$\begin{aligned}
P(\Psi) = \; & \frac{2^{n-1}}{n!(n-1)!} \times \left( \frac{P(N(T) > 0 \mid N(0) =1 )^2 \exp(r(0,T))}{P(N(T) > 0 \mid N(0) = 1)} \right)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} i \times b(t_i) \times P(N(T) > 0 \mid N(t_i) = 1)^2 \exp(r(t_i,T)) \nonumber\\
		= \; & \frac{2^{n-1}}{n!} \times \Big(P(N(T) > 0 \mid N(0) =1 ) \exp(r(0,T))\Big)^2 \nonumber\\
		  \; & \times \prod_{i=2}^{n-1} b(t_i) \times P(N(T) > 0 \mid N(t_i) = 1)^2 \exp(r(t_i,T)).
		\label{eq:tree_probability_substitution}
\end{aligned}$$ 

For a detailed description of this substitution, see {% citet Hoehna2015a %}. Additional
information regarding the underlying birth-death process can be found in
{% citet Thompson1975 %} [Equation 3.4.6] and {% citet Nee1994b %} for constant rates and
{% citet Hoehna2013 Hoehna2014a Hoehna2015a %} for arbitrary rate functions.

To compute the equation above we need to know the rate function,
$r(t,s) = \int_t^s d(x)-b(x) dx$, and the probability of survival,
$P(N(T)\!>\!0|N(t)\!=\!1)$. 
{% citet Yule1925 %} and later {% citet Kendall1948 %} derived the
probability that a process survives ($N(T) > 0$) and the probability of
obtaining exactly $n$ species at time $T$ ($N(T) = n$) when the process
started at time $t$ with one species. Kendall's results were summarized
in Equation (3) and Equation (24) in {% citet Nee1994b %} 

$$\begin{aligned}
P(N(T)\!>\!0|N(t)\!=\!1) & = & \left(1+\int\limits_t^{T} \bigg(\mu(s) \exp(r(t,s))\bigg) ds\right)^{-1} \label{eq:survival} \\ \nonumber \\
P(N(T)\!=\!n|N(t)\!=\!1) & = & (1-P(N(T)\!>\!0|N(t)\!=\!1)\exp(r(t,T)))^{n-1} \nonumber\\
& & \times P(N(T)\!>\!0|N(t)\!=\!1)^2 \exp(r(t,T)) \label{eq:N} %\\
%P(N(T)\!=\!1|N(t)\!=\!1) & = & P(N(T)\!>\!0|N(t)\!=\!1)^2 \exp(r(t,T)) \label{eq:1}
\end{aligned}$$ 

An overview for different diversification models is given in {% citet Hoehna2015a %}.

{% aside Phylogenetic trees as observations %}
The branching processes used here describe probability distributions on
phylogenetic trees. This probability distribution can be used to infer
diversification rates given an “observed” phylogenetic tree. In reality
we never observe a phylogenetic tree itself. Instead, phylogenetic trees
themselves are estimated from actual observations, such as DNA
sequences. These phylogenetic tree estimates, especially the divergence
times, can have considerable uncertainty associated with them. Thus, the
correct approach for estimating diversification rates is to include the
uncertainty in the phylogeny by, for example, jointly estimating the
phylogeny and diversification rates. For the simplicity of the following
tutorials, we take a shortcut and assume that we know the phylogeny
without error. For publication quality analysis you should always
estimate the diversification rates jointly with the phylogeny and
divergence times.
{% endaside %}

