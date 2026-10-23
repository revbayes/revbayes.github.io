---
title: Discrete morphology - Ordered characters
subtitle: Characters whose states evolve in a sequence
authors:  Basanta Khakurel and April Wright
level: 3
order: 2
prerequisites:
- intro
- mcmc
- ctmc
- morph_tree
- morph_tree/multistate
include_all: false
include_files:
- data/Ardeidae.nex
- scripts/model_tree.Rev
- scripts/model_ordered_partition.Rev
- scripts/mcmc_ordered.Rev
index: false
redirect: false
---


{% section Introduction %}

The Mk model, which we have used throughout this tutorial series, treats
the states of a character as unordered labels: a character can change
from any state into any other state in a single step. For many
characters this is exactly what we want. A character such as "shape of
the bill tip: hooked / straight / curved upward" has no natural sequence;
there is no reason to think that a hooked bill has to become straight
before it can become curved upward.

Other characters, however, describe a *sequence*. Think of a character
like "relative length of a bone: short (0) / intermediate (1) / long
(2)". It seems reasonable to assume that a short bone cannot become long
without passing through an intermediate length on the way. Characters
like this are called **ordered** (in the parsimony literature also
*additive*): changing from state 0 to state 2 requires two steps, 0 → 1
and 1 → 2.

The authors of a morphological matrix usually decide which characters
are ordered when they define the characters, and record that decision
in the matrix file. In this tutorial we will see how to model ordered
characters in RevBayes and how to combine them with unordered characters
in the same analysis.


{% subsection The Ordered Rate Matrix | subsec_ordered_Q %}

For a three-state character, the Mk model of {% page_ref morph_tree %}
uses the Jukes-Cantor-type rate matrix in which every state can change
into every other state at the same rate:

$$
Q_{\text{unordered}} = \begin{pmatrix}
-2\mu & \mu & \mu \\
\mu & -2\mu & \mu \\
\mu & \mu & -2\mu
\end{pmatrix}
$$

For an ordered character, we only allow changes between *adjacent*
states. The rates between states 0 and 2 are therefore set to zero:

$$
Q_{\text{ordered}} = \begin{pmatrix}
-\mu & \mu & 0 \\
\mu & -2\mu & \mu \\
0 & \mu & -\mu
\end{pmatrix}
$$

With more states, the same pattern continues: the only non-zero rates
lie immediately above and below the diagonal. Two consequences are
worth keeping in mind:

- **Ordering does not forbid observing states 0 and 2 in two closely
  related taxa.** Over a branch of finite length, a character can make
  both steps (0 → 1 → 2), so the *probability* of going from 0 to 2
  along a branch is not zero. It is, however, smaller than under the
  unordered model, especially on short branches, because two changes are
  needed instead of one.
- **For binary characters, ordering makes no difference.** With only two
  states, the two states are always adjacent, and the ordered and
  unordered rate matrices are identical.


{% section Example: Inferring a Phylogeny of Herons | sec_ordered_analysis %}

{% subsection Data and Files | subsec_data_files %}

>Download the data file [`Ardeidae.nex`](data/Ardeidae.nex) and save it
>to your `data` directory.
{:.instruction}

We use a matrix of 88 morphological characters scored for 34 taxa
{% cite Mayr2019 %}: 26 extant herons, egrets and bitterns (Ardeidae),
five outgroup taxa (a stork, two ibises, the shoebill and the hamerkop),
and three fossil herons. Characters have between two and four states, so
just as in {% page_ref morph_tree/multistate %} we will partition the
matrix by the number of states. In addition, the authors of the matrix
coded 16 of the characters as ordered.

If you open `Ardeidae.nex` in a text editor, you will find the
information about which characters are ordered at the end of the file,
in the `TYPESET` command of an `ASSUMPTIONS` block:

```
TYPESET * UNTITLED  = ord: 1-4 7 9 11 13-17 19 24 41-42, unord: 5-6 8 10 12 18 20-23 25-40 43-88;
```

RevBayes does not read this information from the file (in our copy of
the matrix the block is placed inside a NEXUS comment, `[ ... ]`, so
that RevBayes skips it). Instead, we will tell RevBayes which characters
are ordered in our Rev script.


{% subsection Creating Rev Files | subsec_creating_files %}

>Create the Rev-script files **model_ordered_partition.Rev** and
>**mcmc_ordered.Rev** in your `scripts` directory.
{:.instruction}

We continue to reuse `model_tree.Rev`, unchanged, from
{% page_ref morph_tree %}.


{% subsection Load Data Matrices | subsec_load_data %}

`mcmc_ordered.Rev` starts exactly like the scripts on the previous pages:
{% snippet scripts/mcmc_ordered.Rev %}
morpho <- readDiscreteCharacterData("data/Ardeidae.nex")
{% endsnippet %}
{% snippet scripts/mcmc_ordered.Rev %}
taxa <- morpho.names()
num_taxa <- taxa.size()
num_branches <- 2 * num_taxa - 2
{% endsnippet %}
{% snippet scripts/mcmc_ordered.Rev %}
moves    = VectorMoves()
monitors = VectorMonitors()
{% endsnippet %}
{% snippet scripts/mcmc_ordered.Rev %}
source("scripts/model_tree.Rev")
{% endsnippet %}


{% subsection Splitting Ordered and Unordered Characters | subsec_split %}

In `model_ordered_partition.Rev`, we first write down which characters
are ordered. This is a direct translation of the `ord:` part of the
`TYPESET` command, with the ranges written out (`1-4` becomes
`1, 2, 3, 4`, and so on):
{% snippet scripts/model_ordered_partition.Rev %}
ordered_chars = v(1, 2, 3, 4, 7, 9, 11, 13, 14, 15, 16, 17, 19, 24, 41, 42)
{% endsnippet %}

Next, we make two copies of the data matrix. In the first copy, we
exclude all characters and then include only the ordered ones; in the
second copy, we exclude the ordered characters, which leaves all of the
unordered ones:
{% snippet scripts/model_ordered_partition.Rev %}
morpho_ordered <- morpho
morpho_ordered.excludeAll()
morpho_ordered.includeCharacter(ordered_chars)
{% endsnippet %}
{% snippet scripts/model_ordered_partition.Rev %}
morpho_unordered <- morpho
morpho_unordered.excludeCharacter(ordered_chars)
{% endsnippet %}

>Check that the split worked by typing `morpho_ordered.nchar()` and
>`morpho_unordered.nchar()` in the RevBayes console. You should get 16
>and 72, which add up to the 88 characters of the full matrix.
{:.instruction}


{% subsection Partitioning by Number of States | subsec_partition %}

Now we partition each of the two copies by the number of states, using
the same loop as in {% page_ref morph_tree/multistate %}. This time we
use the largest state in the matrix as the upper bound of the loop:
{% snippet scripts/model_ordered_partition.Rev %}
n_max_states <- morpho.getStateDescriptions().size()
idx = 1
morpho_unordered_bystate[1] <- morpho_unordered
morpho_ordered_bystate[1] <- morpho_ordered
{% endsnippet %}
(Setting the first element of each vector is only needed so that
RevBayes does not complain about an empty element at index 1; the loop
itself starts at two states.)

Within the loop, the unordered characters with `i` states get the usual
`i`-by-`i` Jukes-Cantor rate matrix, exactly as before:
{% snippet scripts/model_ordered_partition.Rev %}
    morpho_unordered_bystate[i] <- morpho_unordered
    morpho_unordered_bystate[i].setNumStatesPartition(i)
    nc = morpho_unordered_bystate[i].nchar()

    if (nc > 0) {
        q[idx] <- fnJC(i)
        m_morph[idx] ~ dnPhyloCTMC(tree=phylogeny, Q=q[idx], nSites=nc, type="Standard")
        m_morph[idx].clamp(morpho_unordered_bystate[i])
        idx = idx + 1
    }
{% endsnippet %}
The ordered characters with `i` states are handled in exactly the same
way. The only difference is the rate matrix: `fnOrderedRateMatrix(i,
1.0, 1.0)` creates an `i`-by-`i` matrix in which only changes between
adjacent states are allowed. The second and third arguments are the
rates of moving one state up (e.g. 0 → 1) and one state down (e.g. 1 →
0). Here, we set both to 1, so that steps in either direction are
equally likely, and RevBayes rescales the matrix so that branch lengths
are still measured in expected changes per character.
{% snippet scripts/model_ordered_partition.Rev %}
    morpho_ordered_bystate[i] <- morpho_ordered
    morpho_ordered_bystate[i].setNumStatesPartition(i)
    nc = morpho_ordered_bystate[i].nchar()

    if (nc > 0) {
        q[idx] <- fnOrderedRateMatrix(i, 1.0, 1.0)
        m_morph[idx] ~ dnPhyloCTMC(tree=phylogeny, Q=q[idx], nSites=nc, type="Standard")
        m_morph[idx].clamp(morpho_ordered_bystate[i])
        idx = idx + 1
    }
{% endsnippet %}

For the heron data, this gives five partitions:

| Characters | 2 states | 3 states | 4 states |
|------------|---------:|---------:|---------:|
| Unordered  | 52       | 12       | 6        |
| Ordered    | 1        | 15       | 0        |

A few things are worth noticing here:

- **The one binary ordered character behaves exactly like an unordered
  one**, because the 2-by-2 ordered and unordered matrices are the same
  (see {% ref subsec_ordered_Q %}). We could just as well have put it
  with the unordered binary characters.
- **`setNumStatesPartition()` groups characters by their largest state,
  not by how many different states were observed.** (RevBayes prints a
  note to remind you of this.) For example, characters 1 and 2 are only
  ever scored as 1 or 2 in this matrix, but they are placed in the
  3-state partition. For ordered characters this is exactly what we
  want: state 0 is part of the sequence, even if no taxon in our matrix
  happens to have it.
- **The counts add up to 86, not 88.** Characters 39 and 73 are scored
  as state 0 in every taxon. Such constant characters have only one
  state, so they do not fall into any of the partitions, which start at
  two states.

Back in `mcmc_ordered.Rev`, we source the model file:
{% snippet scripts/mcmc_ordered.Rev %}
source("scripts/model_ordered_partition.Rev")
{% endsnippet %}


{% subsection Running the Analysis | subsec_run %}

The rest of `mcmc_ordered.Rev` sets up the monitors, runs two
independent MCMC chains, and summarizes the trees, exactly as on the
previous pages:
{% snippet scripts/mcmc_ordered.Rev %}
monitors.append( mnModel(filename="output/ordered.log", printgen=10) )
monitors.append( mnFile(filename="output/ordered.trees", printgen=10, phylogeny) )
monitors.append( mnScreen(printgen=1000, tree_length) )
{% endsnippet %}
{% snippet scripts/mcmc_ordered.Rev %}
mymcmc = mcmc(mymodel, monitors, moves, nruns=2, combine="mixed")
mymcmc.run(generations=20000, tuningInterval=200)
{% endsnippet %}
{% snippet scripts/mcmc_ordered.Rev %}
trace = readTreeTrace("output/ordered.trees", treetype="non-clock")
trace.setBurnin(0.25)
mapTree(trace, file="output/ordered.map.tre")
consensusTree(trace, file="output/ordered.majrule.tre")
{% endsnippet %}

>Run the analysis with `source("scripts/mcmc_ordered.Rev")`.
>This should take about 5 to 10 minutes.
{:.instruction}


{% subsection Results | subsec_results %}

Load `output/ordered_run_1.log` and `output/ordered_run_2.log` into
`Tracer` and check that the two runs agree (see
{% page_ref convergence %}).

Next, open `output/ordered.majrule.tre` in `FigTree` and root it on the
outgroup (*Ciconia*, *Plegadis*, *Threskiornis*, *Balaeniceps* and
*Scopus*). The herons, and within them the bitterns (*Botaurus* and
*Ixobrychus*), should form well-supported clades. Then look for the
three fossils: which of them can be placed with confidence, and which
cannot? Keep in mind that most of their characters are scored as
missing.


{% section Choose Your Own Adventure | sec_ordered_adventure %}

{% subsection What If We Ignore the Ordering? %}

To see what difference the ordering makes, make a copy of
`model_ordered_partition.Rev` and replace `fnOrderedRateMatrix(i, 1.0,
1.0)` with `fnJC(i)`. All characters are then treated as unordered,
while the partitions stay the same. Make a matching copy of
`mcmc_ordered.Rev` that sources the new model file and writes its output
to `output/unordered*`, and run it.

Load both sets of log files into `Tracer`, and compare the two
majority-rule trees:

- Do the well-supported clades change when the ordering is ignored?
- Which of the poorly supported relationships change? Pay particular
  attention to the fossils.
- How do the likelihoods compare? Keep in mind that a higher likelihood
  alone is not a formal model comparison; for that, see
  {% page_ref model_selection_bayes_factors/bf_intro %}.

{% subsection Asymmetric Steps %}

We assumed that steps up and down the sequence of states happen at the
same rate. Because RevBayes rescales the ordered rate matrix, only the
*ratio* of the two rates matters, so we can estimate a single parameter:
how much faster characters step up than down. Try replacing the ordered
rate matrix in your model file with:

```
up_down_ratio ~ dnLognormal(0.0, 1.0)
moves.append( mvScale(up_down_ratio, lambda=0.5, weight=2.0) )
```

placed before the loop, and

```
q[idx] := fnOrderedRateMatrix(i, up_down_ratio, 1.0)
```

inside it (note the `:=`, because the matrix now depends on a
stochastic parameter). A ratio above 1 means that characters tend to
move towards higher-numbered states, and a ratio below 1 the opposite.
Bear in mind that state numbers are only labels chosen by the authors of
the matrix, so a single ratio shared by all ordered characters is only
meaningful if the states were numbered consistently (e.g., always from
small to large). This idea -- that changes in one direction can be more
likely than in the other -- is the topic of the next page.

{% subsection Adding Rate Variation %}

As in {% page_ref morph_tree/multistate %}, you can add among-character
rate variation by defining Gamma-distributed rates before the loop and
passing `siteRates=rates_morpho` to every `dnPhyloCTMC` in the loop.

When you are ready, move on to {% page_ref morph_tree/state_frequencies %},
where we relax the assumption that changes between two states are
equally likely in both directions.
