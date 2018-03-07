---
title: Writing a user tutorial
category: Developer
code_layout: default
---

## Getting started
------------------

## Writing the front matter
------------------
In order for Jekyll to process your tutorial page, it must include YAML front matter, indicated by 

```yaml
---
---
``` 

You will populate the front matter with YAML attributes that are used to organize your tutorial on the RevBayes website. The most basic attributes are `title`, `subtitle`, `authors` which are displayed in the tutorial's title header section. The `category` attribute is used to group tutorials with similar subject matter in the site index.

```yaml
---
title: How to science
subtitle: A postmodern experience
authors: Alice, Bob
category: Miscellaneous
---
``` 

### Including prerequisites

If you would like users to complete other tutorials before they do yours, you can refer them to prequisite tutorials in the overview section, which is populated using the `prerequisites` YAML attribute.

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

### Including data files and scripts
You can include data files (stored under the tutorial subdirectory `data`) and script files (subdirectory `scripts`) in the tutorial overview download by adding them to the `data_files` and `scripts` YAML attributes of your tutorial page.

For example,
```yaml
---
title: How to build a phylogenetic tree
category: Phylogenetics
prerequisites:
    - intro
    - ctmc
data_files:
    - primates.nex
    - primates.tre
scripts:
    - mcmc.Rev
    - model.Rev
---
``` 

## Formatting
------------------

{% preview %}
{% section This is a section header | section1 %}
This is a reference to {% ref section1 %}
{% endpreview %}

{% preview %}
{% subsection This is a subsection header | subsection1 %}
This is a reference to {% ref subsection1 %}
{% endpreview %}

## Code formats

{% preview %}
```
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
{:.default}
{% endpreview %}

`{:.Rev}`
{% preview %}
```
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
{:.Rev}
{% endpreview %}

`{:.bash}`
{% preview %}
```
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
{:.bash}
{% endpreview %}

`{:.Rev-output}`
{% preview %}
```
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
{:.Rev-output}
{% endpreview %}


## Blockquotes

{% preview %}
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
{% endpreview %}

-------------

{% preview %}
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
{:.instruction}
{% endpreview %}

{% preview %}
> ## Discussion header
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
{:.discussion}
{% endpreview %}

## Including citations
------------------
{% preview %}
This is a citation {% cite Felsenstein1981 %}.  
This is an in-text citation of {% citet Felsenstein1981 %}.  
This is a citation with multiple sources {% cite Felsenstein1981 Hoehna2016b %}.
{% endpreview %}

## Including figures
------------------
{% preview %}
{% figure example %}
<img src="images/example.png" width="200">
{% figcaption %}
This is an example figure caption. You can include *Markdown* and $\LaTeX$.
{% endfigcaption %}
{% endfigure %}
  
This is a reference to {% ref example %}
{% endpreview %}