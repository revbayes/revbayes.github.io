---
layout: top
title: Tutorials
subtitle: RevBayes Tutorials
levels:
- Introduction to MCMC and RevBayes
- Standard tree inference and comparative methods
- Complex hierarchical models for phylogenetic inference
---

Several tutorials have been written for RevBayes. Each one explicitly walks you through model specification and analysis set-up for different phylogenetic methods.


### Available Tutorials

This list shows all of the RevBayes tutorials for learning various aspects of RevBayes and Bayesian phylogenetic analysis. 
These tutorials have been written for new users to learn RevBayes at home, at workshops, and in course taught at the undergraduate and graduate levels. 
You may find that the styles are somewhat different between tutorials and that some  have overlapping content. 
The tutorials all follow the same format, please see the Tutorial Format guide for details about how to read the tutorials.

<a href="{{ site.baseurl }}{{ page.url }}format" class="btn btn-info" role="button">Tutorial Format Guide</a>

{% include autocomplete.html keyword=true %}

{% assign keywords = site.empty_array %}

{% assign levels = site.pages | where:"layout","tutorial" | group_by:"level" | reverse %}

{% for level in levels %}
{% if level.name == "" %}
{% continue %}
{% endif %}

{% assign i = level.name | plus:0 %}
{% if page.levels[i] %}
<h3>{{ page.levels[i] }}</h3>
{% else %}
{% continue %}
{% endif %}

<table width="90%" class="table table-striped">
{% assign tutorials = level.items | sort:"index" %}
{% for tutorial in tutorials %}
{% assign keywords = tutorial.keywords | concat: keywords %}
<tr class="tutorial {{ tutorial.keywords | join:' '}}">
<td class="col-xs-5">
{% if tutorial.title-old and tutorial.redirect %}
<a href="https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/{{ tutorial.title-old }}/{{ tutorial.title-old }}.pdf">{{ tutorial.title | markdownify }}</a>
{% else %}
<a href="{{ site.baseurl }}{{ tutorial.url }}">{{ tutorial.title | markdownify }}</a>
{% endif %}
<p style="font-style: italic">{{ tutorial.subtitle }}</p>
</td>

</tr>

{% endfor %}
</table><hr align="left" width="80%">

{% endfor %}

{% include autocomplete.html script=true %}