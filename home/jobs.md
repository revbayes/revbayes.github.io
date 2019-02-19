---
layout: home
title: Jobs
subtitle: Job advertisements related to RevBayes
permalink: /jobs/
---

Throughout the year, the members of the RevBayes development team and our collaborators advertise jobs in our groups related to development in RevBayes.

{% assign jobs = site.pages | where:"layout","jobs" | sort: "appldate" | reverse %}

{% for job in jobs %}
	{% capture appldate %}{{ job.appldate | date: '%s' | divided_by: 3600 | divided_by: 24 }}{% endcapture %}
	{% capture startdate %}{{ job.startdate | date: '%s' | divided_by: 3600 | divided_by: 24 }}{% endcapture %}
    {% if job.enddate %}
        {% capture enddate %}{{ job.enddate | date: '%s' | divided_by: 3600 | divided_by: 24 }}{% endcapture %}
    {% else %}
        {% assign enddate = startdate %}
    {% endif %}
	{% capture title %}{{ job.title }}{% endcapture %}

	{% capture event %}
		<tr class="event" id="{{ appldate }}-{{ title }}">
		<td>{{ job.appldate | date: "%B %-d, %Y" }}</td>
		<td><a href="{{ site.baseurl }}{{ job.url }}">{{ job.title }}</a></td>
		<td>{{ job.location }}</td>
		<td>{{ job.pi | join: ", " }}</td>
		</tr>
	{% endcapture %}

	{% assign events = events | append: event %}
{% endfor %}

<div id="jobs">
<table class="table table-striped" style="width:100%">
<tr class="header">
<td width="15%"><b>Application Date</b></td>
<td width="25%"><b>Job Title</b></td>
<td width="25%"><b>Location</b></td>
<td width="25%"><b>PI</b></td>
</tr>
{{ events }}
<tr>


<script type="text/javascript" src="{{ site.baseurl }}/assets/js/vendor/jquery.min.js"></script>
<script type="text/javascript" src="{{ site.baseurl }}{% link assets/js/jobs.js %}"></script>