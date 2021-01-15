{% section Episodic Diversification Rate Models with Mass Extinctions | models %}

The basic idea behind the model is that speciation, extinction, and fossilization rates are constant within time intervals but can be different between time intervals.
At these time points, the model allows for the possibility of a mass extinction, where every lineage dies instantaneously with some probability $M_i$.
This instantaneous model of mass extinctions allows us to codify the fact that mass extinctions should lead to very large proportions of lineages dying off relatively quickly.
It is important to account for variation in the per-lineage rates of speciation, extinction, and fossilization so that diversificaton-rate shifts are not misinterpreted as mass extinctions.
To do this, we will use a Horseshoe Markov random field model (see the {% page_ref divrate/ebd %} for more specifics).
An overview of the underlying theory of the specific model and implementation is given in {% cite Magee2021 %}.

{% figure fig_ME %}
<img src="figures/ME_tree.png" width="75%" height="75%" />
{% figcaption %}
Two trees simulated under two scenarios of birth-death models.
Tree (A) on the left was simulated without a mass extinction, while tree (B) on the
right experienced as mass extinction at the dashed line.
Both trees contain sampled ancestors as well, but these have been omitted for clarity.
{% endfigcaption %}
{% endfigure %}

{% ref fig_ME %} shows an example of a tree without and a tree with a mass extinction, but with otherwise similar diversification rates.
Note how the tree with a mass extinction contains a band of fossil tips shortly
before the mass extinction time, and few lineages cross the boundary.
This is to be expected, as mass extinctions kill off a majority of lineages alive at that time, thus few lineages survive and what might otherwise be sampled ancestors become tips.


In our inference model, each mass extinction probability will have a reversible jump mixture model
prior with a probability $1 - p_M_i$ that there is *no* mass extinction.
If there is a mass extinction, the probability that a lineage goes extinct at
that time, $M_i$, will be modeled with a Beta distribution.
The probability $p_M_i$ that there is a mass extinction will be small (mass
extinctions are rare), but the probability of a lineage dying in a mass
extinction will be large (most lineages die in a mass extinction).
To model background rate variation, we use the Horseshoe Markov random field
birth-death model as in the {% page_ref divrate/ebd %} tutorial.
