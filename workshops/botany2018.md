---
layout: default
title: RevBayes for Botanists
location: Botany 2018 Conference, Rochester, MN USA
startdate: 2018-07-21
team: Freyman, Zenil-Ferguson, Koch
category: workshop
lessons:
- intro
- ctmc
---

<h1>{{ page.title }}</h1>

<b>Location:</b> {{ page.location }}

<b>Date:</b> {{ page.startdate | date: "%B %-d, %Y" }} 

<b>Instructors:</b> William Freyman, Rosana Zenil-Ferguson, Jordan Koch

<b>Register:</b> [http://2018.botanyconference.org](http://2018.botanyconference.org)

## Description

This workshop will focus on using RevBayes for analysis of botanical data.

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