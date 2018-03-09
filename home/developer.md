---
layout: home
title: Developer
subtitle: Resources for Developers
permalink: /developer
---

### Joining the RevBayes Team

RevBayes is a collaborative software project involving developers from Europe and North America. 
Since RevBayes is open source, everyone is free to clone the [GitHub repository](https://github.com/revbayes/revbayes). 
If you would like to implement new methods or models in any of the RevBayes source code, you can contribute your work to the project by issuing a pull request on GitHub. 
Alternatively, if you are interested in joining the RevBayes development team, please contact [one of the public members](https://github.com/orgs/revbayes/people) to request access.
Also consider attending a RevBayes <a href="{% page_url hackathons %}">hackathon</a> where the developers get together to work on the software. 

Before digging into the developer guide it may be useful to understand the user side of RevBayes. We have provided [tutorials]({% page_url tutorials %}) that walk through the basics of using directed acyclic graphs (DAGs) for conducting phylogenetic analyses in RevBayes.   

### Developer's Guide

The RevBayes Developer's Guide will provide you with the information needed to implement new methods, models, functions, and algorithms in the RevBayes language and core libraries. 


{% assign devguide = site.pages | where:"category", "Developer" | sort: "order","last" %}
<div class="tutorialbox">
{% for lesson in devguide %}
<div class="tutorial">
<a class="title" href="{{ site.baseurl }}{{ lesson.url }}">{{ lesson.title | markdownify }}</a>
<p class="subtitle">{{ lesson.subtitle | markdownify }}</p>
</div>
{% endfor %}
</div>
