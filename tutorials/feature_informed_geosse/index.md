---
title: Feature-informed GeoSSE analysis
subtitle: Historical biogeography using GeoSSE and regional feature-informed rates
authors:  Michael Landis, Sarah Swiston, Sean McHugh
level: 7
order: 1
index: true
redirect: false
prerequisites:
- intro


---

{% section Overview %}

This tutorial covers how to set up files and directories to work effectively in RevBayes {% cite Hoehna2014a Hoehna2016b %}.

{% subsection Downloading and storing data and scripts %}

Many of the RevBayes tutorials will as you to download data and/or scripts.
Let us begin by downloading the data and scripts associated with this tutorial.
For each tutorial that you do, you should create a _directory_, sometimes called a folder, somewhere logical on your computer.
Since we are doing the `tutorial_structure` tutorial, please title your directory `tutorial_structure`.



{% figure example %}
<img src="figures/Directory.png" width="600">
{% figcaption %}
This is an example of the Macintosh File Viewer. In this instance, I have a directoy, `Tutorials` with a subdirectory for this specific tutorial.
{% endfigcaption %}
{% endfigure %}


The above directory structure would be written out like so:

```
~/tutorials/tutorial_structure/
```
{:.bash}


```
   Processing file "scripts/test.Rev"
   Hi there! Welcome to RevBayes! I am now going to read in some test data.
   Successfully read one character matrix from file 'data/primates_and_galeopterus_cytb.nex'
   Congratulations, you set up your scripts and code directories correctly.
```
{:.Rev-output}

In RevBayes, use the `setwd()` command in conjunction with your path to your tutorial to set your working directory.
For example, my command will look like so:

```
setwd("c:\\april\\tutorials\\tutorial_structure")
```

R is a fairly common computing language in biology.
In this section of the tutorial, we will focus on running RevBayes from RStudio. Once you've followed the RStudio instructions on the [installs page](https://revbayes.github.io/gui-setup), you can run use Rev language as you would in a standard RMarkown document.

```{rb}
variable <- "Hi there! Welcome to RevBayes! I am now going to read in some test data."

variable
```

Here's an example of inline LaTeX code: $a + b = c$.

And here's an example of a block of LaTeX code:

$$
f(x) = x^2
$$


{% aside Spaces In Filenames %}
Most scientific programming languages and software does not deal well with spaces in file names.
If you will be doing much scientific computing, it will be best to get in the habit of not using spaces in file and folder names.
{% endaside %}

