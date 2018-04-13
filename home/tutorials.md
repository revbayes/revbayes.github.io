---
layout: home
title: Tutorials
subtitle: RevBayes Tutorials
permalink: /tutorials/
levels:
- Introduction to MCMC and RevBayes
- Model Selection and Testing
- Standard tree inference
- Complex hierarchical models for phylogenetic inference
- Diversification Rate Estimation
- Comparative methods
- Biogeography
---

Several tutorials have been written for RevBayes. Each one explicitly walks you through model specification and analysis set-up for different phylogenetic methods.


### Available Tutorials

This list shows all of the RevBayes tutorials for learning various aspects of RevBayes and Bayesian phylogenetic analysis. 
These tutorials have been written for new users to learn RevBayes at home, at workshops, and in courses taught at the undergraduate and graduate levels. 
You may find that the styles are somewhat different between tutorials and that some  have overlapping content. 
The tutorials all follow the same format. Please see the {% page_ref format %} guide for details about how to read the tutorials.

<a href="{% page_url tutorial %}" class="btn btn-warning" role="button">Contribute!</a>

{% comment %}
{% include keywords.html input=true %}
{% assign keywords = site.empty_array %}
{% endcomment %}

{% assign levels = site.tutorials | sort:"level","last" | group_by:"level" %}
{% for level in levels %}
{% assign i = forloop.index | minus: 1 %}
{% if page.levels[i] %}
<h3>{{ page.levels[i] }}</h3>
{% else %}
<h3>Miscellaneous Tutorials</h3>
{% endif %}

{% assign tutorials = level.items | sort:"order","last" %}

<div class="tutorialbox">
{% for tutorial in tutorials %}
{% if tutorial.index %}

{% comment %}{% assign keywords = tutorial.keywords | concat: keywords %}{% endcomment %}

<div class="tutorial {{ tutorial.keywords | join:' '}}">
{% if tutorial.title-old and tutorial.redirect %}
<a class="title" href="https://github.com/revbayes/revbayes_tutorial/raw/master/tutorial_TeX/{{ tutorial.title-old }}/{{ tutorial.title-old }}.pdf">{{ tutorial.title | markdownify }}</a>
{% else %}
<a class="title" href="{{ site.baseurl }}{{ tutorial.url }}">{{ tutorial.title | markdownify }}</a>
{% endif %}
<p class="subtitle" >{{ tutorial.subtitle | markdownify }}</p>
</div>
{% endif %}

{% endfor %}
</div>

{% endfor %}

{% comment %}{% include keywords.html script=true %}{% endcomment %}
