---
title: Setting up an IDE for RevBayes
subtitle: Setting up XCode, Eclipse, vim
category: Developer
order: 2
ides:
- eclipse
- xcode
- vim
---

The easiest way to get started developing in RevBayes is to use an IDE such as XCode or Eclipse.
You can also use your favorite text editor (e.g. vim or emacs). 
This page will provide some helpful tips on how to set up these development enviroments.
See the {% page_ref software %} page for instructions on how to obtain the source code.

<blockquote class="overview" id="overview">
<h2>Overview</h2>
<ul id="prerequisites">
{% for ide in page.ides %}
<li>{% page_ref {{ ide }} %}</li>
{% endfor %}
</ul>
</blockquote>