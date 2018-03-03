---
layout: developer
title: Implementing functions, distributions, and moves
authors: Jeremy M. Brown, Rosana Zenil-Ferguson, Jordan Koch, Will Pett
category: Developer
---

{% assign developer = site.pages | where:"default", "developer" %}
{% assign implementations = developer | where:"category", "implementation" %}

{% for x in implementations %}
{{x.content}}
{% endfor %}
