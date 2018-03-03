---
layout: default
title: Tutorials
---

# RevBayes User Tutorials

Several tutorials have been written for RevBayes. Each one explicitly walks you through model specification and analysis set-up for different phylogenetic methods.

## Available Tutorials

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
</tr>
{% endif %}
{% endfor %}
</table>
{% endif %}
{% endfor %}
