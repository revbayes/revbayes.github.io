---
layout: default
title: RevBayes for Palaeos
location: University of Bristol, United Kingdom
startdate: 2018-04-30
enddate: 2018-05-04
team: Höhna, Pett, Warnock
category: workshop
lessons:
- intro
- ctmc
---

<h1>{{ page.title }}</h1>

<b>Location:</b> {{ page.location }}

<b>Dates:</b> {{ page.startdate | date: "%-m/%-d" }} to {{ page.enddate | date: "%-m/%-d" }}, {{ page.enddate | date: "%Y" }}

<b>Instructors:</b> Sebastian Höhna, Walker Pett, & Rachel Warnock

## Description

This workshop will focus on using RevBayes for analysis of palaeontological data.

## Schedule

<div class="row">
    <div class="col-md-9">
        <ul>
        {% if page.lessons.size > 0 %}
          {% for lesson in page.lessons %}
            {% assign lesson_url = '/tutorials/' | append: lesson | append: '/' %}
            {% assign tutorial = site.pages | where:"url", lesson_url | first %}
            <li><a href="{{ site.baseurl }}{{ tutorial.url }}">{{ tutorial.title }}</a></li>
          {% endfor %}
        {% else %}
          <li>None</li>
        {% endif %}
        </ul>
    </div>
</div>