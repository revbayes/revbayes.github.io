---
layout: home
title: Tutorial Format
permalink: /tutorials/format
---

These tutorials will provide command line text and code in specific formats.

All commands that are intended to be executed in your Unix terminal will be shown in gray boxes with the `$` prompt. For example:

~~~
cd my_directory
pwd
~~~
{:.bash}

All Rev code will be shown in light blue boxes with the `>` prompt:

~~~
n = 12;
for(i in 1:n) {
	#this is a comment
	i++;
}
~~~
{:.rev}

All output the RevBayes console will be given in light blue boxes with gray text:

~~~
/home/my_directory
~~~
{:.rev-output}

Some tutorials will provide instructions for you that will be highlighted by a box. These instructions will guide you to create new files or other tasks that are not completed in the RevBayes console.

>Make a new file called `m_gtr.Rev`.
{:.instruction}

