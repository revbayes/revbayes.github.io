---
title: Setting up an IDE for RevBayes
subtitle: Setting up XCode, Eclipse, vim
category: Developer
order: 2
ides:
- clion
- eclipse
- xcode
- vim
---

The easiest way to get started developing in RevBayes is to use an IDE such as XCode or Eclipse.
You can also use your favorite text editor (e.g. vim or emacs). 
This page will provide some helpful tips on how to set up these development enviroments.
See the {% page_ref download %} page for instructions on how to obtain the source code.

{% include overview.html %}
{:style='width: 100%;'}

{% for ide in page.ides %}
{% assign ide_page = ide | match_page %}
{{ ide_page.title }}
{:.section.maintitle id="{{ ide_page.name | remove: ".md" }}" }
{{ ide_page.content }}
{% endfor %}