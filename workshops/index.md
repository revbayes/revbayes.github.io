---
layout: default
title: Workshops
---

# RevBayes Workshops

Throughout the year, the members of the RevBayes development team and our collaborators teach workshops on molecular evolution, phylogenetics, and Bayesian inference using RevBayes. 

## Future Workshops featuring RevBayes

{% assign courses = site.pages | where:"category", "workshop" | sort: "startdate" %}
<table class="table table-striped" style="width:90%">
<tr>
<td><b>Date</b></td>
<td><b>Course Title</b></td>
<td><b>Location</b></td>
<td><b>Team</b></td>
</tr>
{% for event in courses %}
<tr>
<td>{{ event.startdate }}</td>
<td><a href="{{ site.baseurl }}{{ event.url }}">{{ event.title }}</a></td>
<td>{{ event.location }}</td>
<td>{{ event.team }}</td>
</tr>
{% endfor %}
</table>



## Past Workshops


