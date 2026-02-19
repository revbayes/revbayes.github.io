---
title: Setting up an IDE for RevBayes
subtitle: Setting up VSCode, XCode, Eclipse, vim, CLion
category: Developer
order: 2
ides:
- cmdline
- vscode 
- xcode
- vim
- clion
- qtcreator
---

One easy way to get started developing in RevBayes is to use an IDE ("Integrated Development Environment")
such as VSCode or QT Creator. 
IDEs are nice because they combine many features such as editing, debugging, compiling, and searching into a single graphical interface.
This page will provide some helpful tips on how to set up these development enviroments.

{% include overview.html %}
{:style='width: 100%;'}

{% for ide in page.ides %}
{% assign ide_page = ide | match_page %}
{{ ide_page.title }}
{:.section.maintitle id="{{ ide_page.name | remove: ".md" }}" }
{{ ide_page.content }}

---
---

{% endfor %}
