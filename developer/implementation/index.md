---
title: Implementing functions, distributions, and moves
subtitle: Getting started with RevBayes development
category: Developer
---

{% include overview.html %}
{:style='width: 100%;'}

{% assign developer = site.pages | where:"layout", "developer" %}
{% assign implementations = developer | where:"category", "implementation" | sort: "order" %}

{% for x in implementations %}
{{ x.title }}
{:.section.maintitle id="{{ x.name | remove: ".md" }}" }
{{x.content}}
{% endfor %}
