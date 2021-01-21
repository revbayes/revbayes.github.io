{% section Overview %}

This tutorial describes how to infer mass extinctions using an episodic fossilized birth-death model in `RevBayes`.
The episodic birth-death model is a process where diversification rates vary episodically through time
and are modeled as piecewise-constant rates {% cite Stadler2011 Hoehna2015a %}.
Your goal is to estimate whether or not there was a mass extinction using Markov chain Monte Carlo (MCMC).

This tutorial builds on the time-varying birth-death model in the {% page_ref divrate/ebd %}
tutorial, where the theory of the underlying time-varying diversification model is covered.
This model allows the incorporation of fossils in the phylogeny, so the
{% page_ref fbd/fbd_specimen %} tutorial may also be of interest.
