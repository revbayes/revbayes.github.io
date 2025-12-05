Saving the beginnings of a serially-sampled HiSSE tutorial...

{% section Setting up a serially-sampled HiSSE model | sec_fHiSSE %}

The hidden SSE (HiSSE) model {% cite Beaulieu2016 %} was introduced to explicitly accommodate the role of
unobserved effects on diversification rates.
This alleviated some of the more complicated issues in BiSSE, as it was shown to falsely identify trait-associated
hetereogeneity when the source of heterogeneity was not included in the model {% cite Rabosky2015 %}.
See [the HiSSE tutorial]({{ base.url }}/tutorials/sse/hisse) for more information on the model.

We only need to make minor modifications to our BiSSE script to make it into a HiSSE model.
The easiest way to proceed would therefore be to make a copy of your BiSSE script, renaming it as appropriate,
and make the changes we mention below.
If a part of the script is not mentioned, assume it remains unchanged (e.g. the lines to read `tree` and `data`
remain the same, since we are using the same fixed tree and same observed characters).

First, in addition to our `num_states` variables as before, we must create new variables to
hold the number of hidden states, and the total number of states.

{{ hisse_script | snippet:"block#", "4-5" }}

We are using only two hidden states, which we call A and B.
While it is possible to include more hidden states, since these are unobserved states for which we have no data,
one should proceed with caution including more parameters.

Then, we must expand our `data` object to include the hidden states

{{ hisse_script | snippet:"block#", "8" }}

Now the character in `data_exp` has four states.
By default, RevBayes sets up state numbers to follow the order of observed, then hidden.
So here, states 1 and 2 correspond to 0A and 1A, and states 3 and 4 to 0B and 1B.

To set up our speciation, extinction, and fossil sampling rates, we follow the exact same procedure as in the
BiSSE case, but with `num_rates` rates instead.

{{ hisse_script | snippet:"block#", "9-13" }}

Note that this sets each rate to be independent.
While that is the most flexible set up, some analyses might run into "label-swapping" issues.
Label-swapping occurs because the likelihood of the model does not change if the states A and B are switched,
since there is no data associated with those states.
As such, the assignment of each state might switch throughout the MCMC, making it so that each rate parameter's
posterior distribution is actually a mixture between the corresponding rates.
If you encounter such problems in your analyses, see [the HiSSE tutorial]({{ base.url }}/tutorials/sse/hisse) for
a way to set rates that guarantees there will be no label-swapping (sacrificing a small amount of flexibility in
the process).

To set up the rate matrix, we can create variables for `q_obs` and `q_hidden`, corresponding to $q_{01}$ and \
$q_{10}$, and $q_{AB}$ and $q_{BA}$ respectively.
We can then use `fnHiddenStateRateMatrix` to build the full rate matrix.

{{ hisse_script | snippet:"block#", "14-18" }}

Note that this set up assumes that transitions between rate categories with the same observed state occur at the
same rate (i.e. $q_{0A->0B} = q_{1A->1B} = q_{AB}$), and similarly for categories with the same hidden state.
While this is often a useful assumption (and one that was 

