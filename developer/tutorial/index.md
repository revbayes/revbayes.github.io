---
title: Writing a user tutorial
subtitle: How to write RevBayes tutorials for this website
layout: developer
category: Developer
code_layout: Rev
data_files:
- example.nex
scripts:
- example.Rev
---

{% section Getting started %}

This tutorial will take you through the steps of writing a new RevBayes tutorial for this website. 

In order to build and test your tutorial, you will need to download and host an instance of the RevBayes website on your local machine. The site was built using [Jekyll](https://jekyllrb.com) and is hosted by [GitHub Pages](https://pages.github.com/). Please refer to the README.md in the site's [GitHub repository](https://github.com/revbayes/revbayes-site) for instructions on setting up and hosting the site on your computer.

This website is generated from simple plain-text files in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) format with [YAML](http://camel.readthedocs.io/en/latest/yamlref.html) front matter, with additional support for accessing/modifying page attribute data using [Liquid](https://help.shopify.com/themes/liquid) templates. This tutorial presumes the reader is already at least somewhat familiar with these markup tools.

{% subsection Tutorial directory structure %}

Each tutorial follows the same general file organization:

<pre>
revbayes.github.io
└── tutorials
    └── <font color="red">new_tutorial
        ├── data/
        ├── scripts/
        ├── figures/
        └── index.md</font> <-- main text of tutorial
</pre>

Specifically, your new RevBayes tutorial should be placed in its own directory (e.g. `new_tutorial`) under the `tutorials` directory of the root website repository. The main text of the tutorial should be written in the Markdown file `index.md`, and if the tutorial uses additional data, scripts or image files they should be stored in the subdirectories `data`, `scripts` and `figures` respectively. Your tutorial can include additional pages or other files, but the above basic components are used in integrating your tutorial with the rest of the website.

{% subsection Creating the `index.md` file %}

In order for Jekyll to process your tutorial's index page, it must include YAML front matter, indicated by 

```yaml
---
---
``` 

You will populate the front matter with YAML attributes that are used to organize your tutorial on the RevBayes website. The most basic attributes are `title`, `subtitle`, `authors` which are displayed in the tutorial's title header section.

The `category` attribute is used to group tutorials with similar subject matter in the site index.
At the moment, only three main categories are recognized: `Basic` for tutorials not including phylogenetic methods, `Standard` for tutorials covering widely-used phylogenetic methods and `Advanced` for more specialized topics in phylogenetics.

```yaml
---
title: How to science
subtitle: A postmodern experience
authors: Alice, Bob
category: Basic
---
``` 

<!-- You can also include `keywords` as a YAML list attribute which can be used to help lead users to your tutorial from other related tutorials.

```yaml
category: Standard
keywords:
    - diversification
    - birth-death
    - relaxed-clock
```  -->

{% section Filling in the overview box %}

At the top of each tutorial, an **Overview** box is displayed with a list of prerequisite tutorials and a table of contents. Take another look at the [overview for this tutorial](#overview).

{% subsection Including prerequisites %}

If you would like users to complete other tutorials before they do yours, you can refer them to prequisite tutorials in the tutorial's overview section, which is populated using the `prerequisites` YAML attribute.

```yaml
---
title: Non-parametric interdimensional Bayesian hyperloop methods
category: Advanced phylogenetics
prerequisites:
    - intro
    - ctmc
    - habilitation
---
``` 

Prerequisite tutorials are referred to by the name of their containing directory in the `tutorials` directory.

{% subsection Filling in the table of contents %}

To create a heading that will be included in the table of contents, you can use the `section` and `subection` Liquid tags, which take the heading text and anchor id as arguments, separated by a pipe `|`. Sections are referenced using the `ref` tag.

{% preview %}
{% section This is a section header | section1 %}

This is a reference to {% ref section1 %}
{% endpreview %}

{% preview %}
{% subsection This is a subsection header | subsection1 %}

This is a reference to {% ref subsection1 %}
{% endpreview %}

You can also create a manually-formatted section/subsection heading by tagging it with the HTML class `section` or `subection`. In general, any block of text can be manually tagged with any class using the `{:.class}` syntax.

{% preview %}
## This section heading was tagged manually
{:.section}

### This subsection heading was tagged manually
{:.subsection}
{% endpreview %}

The anchor id of a manually-tagged section heading is automatically generated by changing the heading text to lower case and replacing spaces with hyphens. You must link to it using the normal Markdown URL syntax.

{% preview %}
[Manually-tagged section heading](#this-section-heading-was-tagged-manually)
{% endpreview %}

{% section Including data files and scripts %}

At the top of each tutorial, the **Data files and scripts** box contains a list of files that can be downloaded by clicking the <span class='glyphicon glyphicon-download'></span> icon.

{% include download.html %}

You can include data files (stored under the tutorial subdirectory `data`) and script files (subdirectory `scripts`) in the download box by adding them to the `data_files` and `scripts` YAML attributes of your tutorial page.

```yaml
---
title: How to build a phylogenetic tree
category: Phylogenetics
data_files:
    - example.nex
scripts:
    - example.Rev
---
``` 

{% section Formatting code %}

You can format code using the <code>```</code> or <code>~~~</code> fenced code delimiters. By default, tutorial code is formatted for Rev code
{% preview %}
```
for (i in 1:n_branches) {
   br_lens[i] ~ dnExponential(10.0)
   moves[mvi++] = mvScale(br_lens[i]) 
}
```
{% endpreview %}

Code representing output from the Rev console can be formatted using the `{:.Rev-output}` tag

{% preview %}
```
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
{:.Rev-output}
{% endpreview %}

{% subsection Other formatting options %}

Other code formats can be assigned using the `{:.}` syntax.

`{:.bash}` - bash console input
{% preview %}
```
ls tutorials
grep phylogenetics index.md
```
{:.bash}
{% endpreview %}

`{:.instruction}` - Instruction box

{% preview %}
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
{:.instruction}
{% endpreview %}

`{:.discussion}` - Optional discussion information box

{% preview %}
> ## Discussion header
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
{:.discussion}
{% endpreview %}

**Blockquote**

{% preview %}
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
{% endpreview %}

{% section Math notation %}

Mathematical notation using $\LaTeX$ symbols are rendered with [MathJax](https://www.mathjax.org/). You can write inline math using the `$...$`, `$$...$$` or `\\(...\\)` delimiters, while display math uses `\\[...\\]`.
You can alternatively write display math using `$$...$$` if it is separated from the previous text by a line break.

{% preview latex %}
Inline math
$S = \mathbb{R}$
$$f(x) = x^2$$
\\(\implies \min_{x\in S}f(x) = 0\\)
is cool

Display math \\[f(a) = \frac{1}{2\pi i}\int_{\gamma}\frac{f(z)}{z-a}dz\\]

Alternative display math

$$\int(1-e^{-x})^n\,dx=x-\sum_{p=1}^n\tfrac{1}{p}(1-e^{-x})^p$$
{% endpreview %}

{% section Modularizing your tutorial %}

You can modularize your tutorial by putting major sections in separate markdown files in your tutorial directory. These can be included in the main text using the `include_relative` Liquid tag. Make sure that *only* the main text Markdown file contains YAML front matter.

For example, if you have an external file [`external_file.md`](external_file.md) with the following contents

```
{% include_relative external_file.md %}
```
{:.default}

You can include it in the main text as follows
{% preview %}
{% include_relative external_file.md %}
{% endpreview %}

{% subsection Making alternative versions of your tutorial %}

Any Markdown file in your tutorial directory will be rendered as a separate tutorial as long as it has YAML front matter. For example, if we make copy of the same external file (say `external_file-yaml.md`) and simply add an empty front matter section, then Jekyll will automatically generate [this page](external_file-yaml.html) when building the website.

This makes it easy for you to create alternative versions of your tutorial. Each alternative versions is built from a Markdown file with YAML front matter, each of which then includes one or more external Markdown module text files that do not include front matter. Consider the following example modular tutorial structure.

<pre>
new_tutorial
├── data/
├── scripts/
├── figures/
├── modules/ <font color="red"><-- module files (no front matter)</font>
│   ├── intro.md
│   ├── exercise1.md
│   ├── exercise2.md
│   └── exercise3.md
├── index.md <font color="red"><-- tutorial page (with front matter)</font>
└── v2.md    <font color="red"><-- tutorial page (with front matter)</font>
</pre>

In this example, there are two versions of the tutorial, both of which will get listed on the main [Tutorials Page]({{site.baseurl}}/tutorials/). The default version of the tutorial will be rendered at the relative URL `{{site.baseurl}}/tutorials/new_tutorial/`, while `v2.md` will render at the URL `{{site.baseurl}}/tutorials/new_tutorial/v2.html`.

{% section Figures %}

Figures can be included from the `figures` subdirectory (or elsewhere) using the `figure` and `figcaption` Liquid tags.

{% preview %}
{% figure example %}
<img src="figures/example.png" width="200">
{% figcaption %}
This is an example figure caption. You can include *Markdown* and $\LaTeX$.
{% endfigcaption %}
{% endfigure %}
  
This is a reference to {% ref example %}
{% endpreview %}

{% section Citations and bibliography %}

You can include a citation using the `cite` and `citet` Liquid tags. Figures are referenced using the `ref` tag.

{% preview %}
This is a citation {% cite Felsenstein1981 %}.  
This is an in-text citation of {% citet Felsenstein1981 %}.  
This is a citation with multiple sources {% cite Felsenstein1981 Hoehna2016b %}.
{% endpreview %}

Citations are included in the **References** section at the end of each tutorial. References are formatted according to the [CSL](https://github.com/citation-style-language/styles) style for [*Systematic Biology*](https://academic.oup.com/sysbio).

{% include bibliography.html %}

{% section Controling printed output %}

You can prevent any element from being printed when the tutorial is sent to PDF or a printer by tagging it with `{:.no-print}`.
