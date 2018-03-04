---
layout: default
title: Tutorials
---

# RevBayes User Tutorials

Several tutorials have been written for RevBayes. Each one explicitly walks you through model specification and analysis set-up for different phylogenetic methods.


## Available Tutorials

This list shows all of the RevBayes tutorials for learning various aspects of RevBayes and Bayesian phylogenetic analysis. 
These tutorials have been written for new users to learn RevBayes at home, at workshops, and in course taught at the undergraduate and graduate levels. 
Thus, you may find that the styles are somewhat different between tutorials and that some  have overlapping content. 
The tutorials all follow the same format, please see the Tutorial Format guide for details about how to read the tutorials.

<a href="{{ site.baseurl }}{{ page.url }}format" class="btn btn-info" role="button">Tutorial Format Guide</a>

{% assign tutorials = site.pages | where:"layout", "tutorial" %}
{% assign categories = tutorials | group_by:"category" | sort: "index" %}
{% for category in categories %}
{% if category.name != "Developer" and category.name != "" %}
<h3>{{ category.name }}</h3>
<table class="table table-striped">
{% for lesson in tutorials %}
{% if lesson.category == category.name %}
<tr>
<td class="col-sm-3">
{% assign lesson_number = lesson_number | plus: 1 %}
{{ lesson_number }}. <a href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title }}</a>
</td>
<td class="col-sm-3">{{ lesson.subtitle }}</td>
</tr>
{% endif %}
{% endfor %}
</table>
{% endif %}
{% endfor %}
