---
layout: default
---

# RevBayes Tutorials

Several tutorials have been written for RevBayes. Each one explicitly walks you through model specification and analysis set-up for different phylogenetic methods.


## Available Tutorials

This list shows all of the RevBayes tutorials for learning various aspects of RevBayes and Bayesian phylogenetic analysis. 
These tutorials have been written for new users to learn RevBayes at home, at workshops, and in course taught at the undergraduate and graduate levels. 
Thus, you may find that the styles are somewhat different between tutorials and that some  have overlapping content. 
The tutorials all follow the same format, please see the Tutorial Format guide for details about how to read the tutorials.

<a href="{{ site.baseurl }}{{ page.url }}format" class="btn btn-info" role="button">Tutorial Format Guide</a>

{% assign alltutorials = site.pages | where:"layout", "tutorial" %}
{% assign tutorials = alltutorials | where:"category", "Basic" | sort: "index" %}
<h3>Introduction to MCMC and RevBayes</h3>
<table class="table table-striped">
{% for lesson in tutorials %}
<tr>
<td class="col-sm-3">
<a href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title }}</a>
</td>
<td class="col-sm-3">{{ lesson.subtitle }}</td>
</tr>
{% endfor %}
</table>

{% assign alltutorials = site.pages | where:"layout", "tutorial" %}
{% assign tutorials = alltutorials | where:"category", "Standard" | sort: "index" %}
<h3>Standard tree inference and comparative methods</h3>
<table class="table table-striped">
{% for lesson in tutorials %}
<tr>
<td class="col-sm-3">
<a href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title }}</a>
</td>
<td class="col-sm-3">{{ lesson.subtitle }}</td>
</tr>
{% endfor %}
</table>

{% assign alltutorials = site.pages | where:"layout", "tutorial" %}
{% assign tutorials = alltutorials | where:"category", "Advanced" | sort: "index" %}
<h3>Complex hierachical models for phylogenetic inference</h3>
<table class="table table-striped">
{% for lesson in tutorials %}
<tr>
<td class="col-sm-3">
<a href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title }}</a>
</td>
<td class="col-sm-3">{{ lesson.subtitle }}</td>
</tr>
{% endfor %}
</table>

{% assign alltutorials = site.pages | where:"layout", "tutorial" %}
{% assign tutorials = alltutorials | where:"category", "In Progress" | sort: "index" %}
<h3>Tutorials that are currently in development</h3>
<table class="table table-striped">
{% for lesson in tutorials %}
<tr>
<td class="col-sm-3">
<a href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title }}</a>
</td>
<td class="col-sm-3">{{ lesson.subtitle }}</td>
</tr>
{% endfor %}
</table>


