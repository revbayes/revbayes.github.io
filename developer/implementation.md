---
layout: tutorial
title: Implementing functions, distributions, and moves
subtitle: Getting started with RevBayes development
authors: Jeremy M. Brown, Rosana Zenil-Ferguson, Jordan Koch, Will Pett
category: Developer
---

{% assign developer = site.pages | where:"layout", "developer" %}
{% assign implementations = developer | where:"category", "implementation" | sort: "index" %}

{% for x in implementations %}
{{x.content}}
{% endfor %}
