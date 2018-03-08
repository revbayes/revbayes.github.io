---
layout: top
title: Workshops
subtitle: RevBayes Workshops
---

Throughout the year, the members of the RevBayes development team and our collaborators teach workshops on molecular evolution, phylogenetics, and Bayesian inference using RevBayes. Additionally, we have occasional <a href="{{ site.baseurl }}{{ page.url }}hackathons">hackathons</a> which bring together developers to work on the software and methods for phylogenetic analysis. 

{% assign workshops = site.pages | where:"layout","workshop" | sort: "startdate" %}

{% capture nowunix %}{{'now' | date: '%s'}}{% endcapture %}

{% for workshop in workshops %}
	{% capture startdate %}{{ workshop.startdate | date: '%s'}}{% endcapture %}

{% capture event %}
<tr>
<td>{{ workshop.startdate | date: "%B %-d, %Y" }}</td>
<td><a href="{{ site.baseurl }}{{ workshop.url }}">{{ workshop.title }}</a></td>
<td>{{ workshop.location }}</td>
<td>{{ workshop.instructors | join: ", " }}</td>
</tr>
{% endcapture %}

	{% if startdate > nowunix %}
		{% assign future = future | append: event %}
	{% else %}
		{% assign past = past | append: event %}
	{% endif %}
{% endfor %}

{% capture future_table %}
<table class="table table-striped" style="width:100%">
<tr>
<td width="15%"><b>Date</b></td>
<td width="25%"><b>Course Title</b></td>
<td width="25%"><b>Location</b></td>
<td width="25%"><b>Instructors</b></td>
</tr>
{{ future }}
</table>
{% endcapture %}

{% capture past_table %}
<table class="table table-striped" style="width:100%">
<tr>
<td width="15%"><b>Date</b></td>
<td width="25%"><b>Course Title</b></td>
<td width="25%"><b>Location</b></td>
<td width="25%"><b>Instructors</b></td>
</tr>
{{ past }}
</table>
{% endcapture %}

### Future Workshops

{% if future_table %}
{{ future_table }}
{% else %}
**No upcoming workshops**
{% endif %}

### Past Workshops

{% if past_table %}
{{ past_table }}
{% else %}
**No past workshops**
{% endif %}
