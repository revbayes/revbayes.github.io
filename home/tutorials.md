---
layout: home
title: Tutorials
subtitle: RevBayes Tutorials
permalink: /tutorials
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

<a href="{% page_url format %}" class="btn btn-info" role="button">Tutorial Format Guide</a>


{% assign keywords = site.empty_array %}

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
{% assign keywords = tutorial.keywords | concat: keywords %}

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