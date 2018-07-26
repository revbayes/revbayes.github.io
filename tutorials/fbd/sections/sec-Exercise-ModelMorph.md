{% subsection Modeling the Evolution of Binary Morphological Characters | Exercise-ModelMorph %}

In this section we will define the model of morphological character evolution.

> Open your text editor and create the morphological character model file
> called `{{ morph_script }}` in the `scripts` directory.
{:.instruction}

As stated in the introduction ({% ref Intro-Morpho %}) we will
use Mk to model our data. Because the Mk model is a generalization of
the Jukes-Cantor model, we will initialize our Q matrix from a Jukes-Cantor
matrix.

{{ morph_script | snippet:"block#","1" }}

As in the molecular data partition, we will allow gamma-distributed rate
heterogeneity among sites.

{{ morph_script | snippet:"block#","2-3" }}

The phylogenetic model also assumes that each branch has a rate of
morphological character change. For simplicity, we will assume a strict
exponential clock—meaning that every branch has the same rate drawn from
an exponential distribution (see {% ref Intro-MorphClock %}).

{{ morph_script | snippet:"block#","4-5" }}

As in our molecular data partition, we now combine our data and our
model in the phylogenetic CTMC distribution. There are some unique
aspects to doing this for morphology.

You will notice that we have an option called `coding`. This option
allows us to condition on biases in the way the morphological data were
collected (ascertainment bias). The option `coding=variable` specifies
that we should correct for coding only variable characters (discussed in
{% ref Intro-Morpho %}).

{{ morph_script | snippet:"block#","6" }}

You have completed the morphology model file. Save `model_Morph.Rev` in
the `scripts` directory.

We will now move on to the next model file.