---
title: Best practices in RevBayes
subtitle: Coding and documentation guidelines
category: Developer
---

{% include overview.html %}
{:style='width: 100%;'}

{% assign developer = site.pages | where:"layout", "developer" %}
{% assign best_practices = developer | where:"category", "best_practices" | sort: "order" %}

{% for x in best_practices %}
{{ x.title }}
{:.section.maintitle id="{{ x.name | remove: ".md" }}" }
{{x.content}}
{% endfor %}
