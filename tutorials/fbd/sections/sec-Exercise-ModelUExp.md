{% subsection The Uncorrelated Exponential Relaxed Clock Model | Exercise-ModelUExp %}

We will now define the molecular relaxed clock model.

> Open your text editor and create the lineage-specific branch-rate model
> file called `{{ uexp_script }}` in the `scripts` directory.
>
>Enter the Rev code provided in this section in the new model file.
{:.instruction}

For our hierarchical, uncorrelated exponential relaxed clock model
(described in section {% ref Intro-GTR-UExp %} and shown in
{% ref fig_uexp_gm %}), we first define the mean branch rate as an
exponential random variable. Then, we specify scale proposal moves on
the mean rate parameter.

{{ uexp_script | snippet:"block#","1-2" }}

Before creating a rate parameter for each branch, we need to get the
number of branches in the tree. For rooted trees with $n$ taxa, the
number of branches is $2n-2$.

{{ uexp_script | snippet:"block#","3" }}

Then, use a for loop to define a rate for each branch. The branch rates
are independent and identically exponentially distributed with mean
equal to the mean branch rate parameter we specified above. For each
rate parameter we also create scale proposal moves.

{{ uexp_script | snippet:"block#","4" }}

Lastly, we use a vector scale move to propose changes to all branch
rates simultaneously. This way we can sample the total branch rate
independently of each individual rate, which can improve mixing.

{{ uexp_script | snippet:"block#","5" }}

You have completed the molecular relaxed clock model file. Save `model_UExp.Rev` in
the `scripts` directory.

