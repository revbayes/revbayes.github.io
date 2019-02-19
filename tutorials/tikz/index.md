---
title: Building Graphical Models using TikZ (incomplete tutorial)
subtitle: Using the TikZ/PGF package and LaTeX tools to make figures of graphical models. 
authors:  Tracy A. Heath
level: 0
order: 0.75
prerequisites:
- intro
index: false
---

{% section Introduction | introduction %}

This tutorial will demonstrate how to make clean-looking graphical models using 
[TikZ/PGF](http://www.texample.net/tikz/) and LaTeX. These are the tools
that the RevBayes team use to make figures like those used in papers 
{% cite Hoehna2014b Hoehna2016b %} and in many of the tutorials and documentation
for RevBayes (*e.g.*, {% page_ref ctmc %}). {% ref fig_fbd_gm %} shows the graphical
model for the [tutorial on the fossilized birth-death process](../fbd), which was entirely generated
using tikz. Visualizations of graphical models are incredibly useful for communicating the details
of the model. These visualizations can be used in scientific papers and when teaching
statistical modeling.

{% figure fig_fbd_gm %}
<img src="../fbd/figures/tikz/fbd_gm.png" width="400" /> 
{% figcaption %} 
A graphical model of the fossilized
birth-death model describing the generation of the time tree.
More details about this model can be found in {% page_ref fbd %}
{% endfigcaption %}
{% endfigure %}


{% section Tools for Generating TikZ Figures | tools %}

Before you can start building and generating graphs using TikZ, there are a few prerequisites.

1. You must have [LaTeX installed](https://www.latex-project.org/get/). This tutorial also assumes
that you have some understanding of TeX/LaTeX. 
2. You may find that a simple tool like [LaTeXiT](https://www.chachatelier.fr/latexit/) is the best approach for generating individual, stand-alone
image files that you can use in different types of documents.
3. If you'd like to create a TikZ figure within your LaTeX document, like in an article or beamer slide-show,
it is recommended that you use a LaTeX IDE or text editor. Alternatively, you can edit and compile a LaTeX document
using online editors like [Overleaf](https://www.overleaf.com) and [ShareLaTeX](https://www.sharelatex.com/).


{% section A Simple Stand-alone Graphical Model using LaTeX | simple1 %}

To draw a simple graphical model, we can create a custom document in LaTeX. We will do this in a single
`.tex` file. 

>Open your LaTeX IDE (either [online](https://www.overleaf.com) or locally) or text editor. You can name this file `simple_model_gm.tex`.
{:.instruction}

Now that you have an open file, we can begin by adding the different components.
This TeX document will begin with the required specification of the document class.

```tex
\documentclass[12pt]{article}
```

Then we can use the `geometry` package to set the dimensions of the page. This will make the page
a 5 by 5 inch square. If you create a very large model, you may have to change the page dimensions in order to
accommodate the whole graph. We will additionally make it so our document does not have any page numbers. 

```tex
\usepackage[paperwidth=5in, paperheight=5in]{geometry}
\pagestyle{empty}
```

Now that we have created the document, we can next specify TikZ-specific settings. First, we will include the `tikz`
package.

```tex
\usepackage{tikz}
```

TikZ has internal libraries that allow for some nice features. The `calc` TikZ library `calc` enables us to place elements relative to one another.

```tex
\usetikzlibrary{calc}
```

