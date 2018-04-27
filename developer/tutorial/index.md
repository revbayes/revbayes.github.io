---
title: Contributing a RevBayes tutorial
subtitle: How to write and host a tutorial on this website
layout: default
category: Developer
code_layout: Rev
include_files:
- example.nex
- example.Rev
---

{% include title.html %}
{% include overview.html %}

{% section Getting started %}

This tutorial will take you through the steps of contributing a new RevBayes tutorial to this website. 

In order to build and test your tutorial, you will need to download and host an instance of the RevBayes website on your local machine. The site was built using [Jekyll](https://jekyllrb.com/docs/templates/) and is hosted by [GitHub Pages](https://pages.github.com/). Please refer to the README.md in the site's [GitHub repository](https://github.com/revbayes/revbayes-site) for instructions on setting up and hosting the site on your computer.

This website is generated from simple plain-text files in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) format with [YAML](http://camel.readthedocs.io/en/latest/yamlref.html) front matter, with additional support for accessing/modifying page attribute data using [Liquid](https://help.shopify.com/themes/liquid) templates. This tutorial presumes the reader is already at least somewhat familiar with these markup tools.

{% subsection Tutorial directory organization %}

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

Specifically, your new RevBayes tutorial should be placed in its own directory (e.g. `new_tutorial`) under the `tutorials` directory of the root website repository. The main text of the tutorial should be written in a Markdown file named `index.md` (although any unique name will work). If the tutorial uses additional data, scripts or image files they should be stored in the subdirectories `data`, `scripts` and `figures` respectively. Your tutorial can include additional pages or other files, but the above basic components are used in integrating your tutorial with the rest of the website.

{% subsection Writing tutorial front matter %}

In order for Jekyll to process your tutorial's page, it must include YAML front matter, indicated by 

```yaml
---
---
``` 

You will populate the front matter with YAML attributes that are used to organize your tutorial on the RevBayes website. The most basic attributes are `title`, `subtitle`, `authors` which are displayed in the tutorial's title header section.

```yaml
---
title: How to science
subtitle: A postmodern experience
authors:
- Alice
- Bob
level: 0
---
``` 

The `level` attribute is used to group tutorials with similar levels of complexity in the [tutorial index]({% page_url tutorials %}).
At the moment, only these levels are recognized:
{% assign tutorials_index = "tutorials" | match_page %}
{% for level in tutorials_index.levels %}
`level: {% increment counter %}` is for *{{level}}*
{% endfor %}

Any other level is for *Miscellaneous tutorials*

{% subsection Front matter attributes %}

Here is a glossary of all the tutorial attributes used by this site.
{% table glossary %}
 Attribute  |  Description
----------- | -----------
 `title`    | Tutorial title displayed in the title header and the [tutorial index]({% page_url tutorials %})
 `subtitle` | Italicized description displayed below the title.
 `authors`  | Title authors. Displayed in the title header.
 `level`    | Numeric level 0-2 indicating basic, intermediate or advanced subject matter.
 `prerequisites` | List of prerequisite tutorials.
 `include_files` | List of file name patterns that should be included in the tutorial file download.
 `exclude_files` | List of file name patterns that should not be included in the download (overrides matching `include_files`).
 `index` | Boolean indicating whether the tutorial should be included in the main [tutorial index]({% page_url tutorials %})
 `order` | Number indicating the order in which this tutorial should appear in its level in the [tutorial index]({% page_url tutorials %}).
 `keywords` | List of keywords for grouping tutorials with related subject matter.
 `title-old`| Name of the corresponding tutorial in the deprecated [Latex repository](https://github.com/revbayes/revbayes_tutorial)
 `redirect` | Automatically redirect to the deprecated Latex tutorial? Used for tutorials not yet updated for this site.
 `permalink` | Address relative to `{% raw %}{{ baseurl }}{% endraw %}` where you want the tutorial to be accessible on the internet. You may identify the primary version of your tutorial by setting this to the relative path of your tutorial's home directory.
{% endtable %}

{% section Filling in the overview box %}

At the top of each tutorial, an **Overview** box is displayed with a list of prerequisite tutorials and a table of contents. Take another look at the [overview for this tutorial](#overview).

{% subsection Including prerequisites %}

If you would like to refer users to prequisite tutorials in the tutorial's overview section, list the names of the prequisite tutorials in the `prerequisites` YAML attribute. Tutorials can be referred to by any unique path identifier, ignoring `index.md` and `.md` suffixes.

```yaml
prerequisites:
- intro
- ctmc
- clocks/simple
```

{% subsection Filling in the table of contents %}

To create a heading that will be included in the table of contents, you can use the `section` and `subection` Liquid tags, which take the heading text and anchor id as arguments, separated by a pipe `|`. Sections are referenced using the `ref` Liquid tag.

{% preview %}
{% section This is a section header | section1 %}

This is a reference to {% ref section1 %}
{% endpreview %}

{% preview %}
{% subsection This is a subsection header | subsection1 %}

This is a reference to {% ref subsection1 %}
{% endpreview %}

{% subsection Manually tagging sections %}

You can also create a manually-formatted section/subsection heading by tagging it with the HTML class `section` or `subection`. In general, any block of text can be manually tagged with any class using the `{:.class}` syntax.

{% preview %}
## This section heading was tagged manually
{:.section}

### This subsection heading was tagged manually
{:.subsection}
{% endpreview %}

The anchor id of a manually-tagged section heading is automatically generated by changing the heading text to lower case and replacing spaces with hyphens. You must link to a manually-tagged section using the normal Markdown URL syntax.

{% preview %}
[Manually-tagged section heading](#this-subsection-heading-was-tagged-manually)
{% endpreview %}

You can provide your own id by including it along with the class, or with the `{#id}` syntax. The following two snippets are equivalent.

> ```markdown
> ### This subsection heading has a custom id
> {:.subsection id="heading1"}
> ```
{:style="margin-bottom: 0"}
{% preview %}
### This subsection heading has a custom id {#heading1}
{:.subsection}
{% endpreview %}

Again, you must link to this heading manually.

{% preview %}
[Subsection heading with custom id](#heading1)
{% endpreview %}

{% section Including data files and scripts %}

At the top of each tutorial, the **Data files and scripts** box contains a list of files that can be downloaded by clicking the <span class='glyphicon glyphicon-download'></span> icon.

{% include download.html %}

Files in the `data` and `scripts` directories of your tutorial are added to the *Data files and scripts* box automatically. You can include files from another tutorial by listing their relative paths in the `include_files` YAML front matter attribute. You can exclude files using the `exclude_files` attribute.

```yaml
include_files:
    - ctmc/data/primates_and_galeopterus_cytb.nex
exclude_files:
    - data/useless_file.nex
```

{% section Including script snippets %}

You can dynamically include snippets from your script files using the `snippet` filter. You can extract a range of line numbers using the `lines` option, or you can extract a block of text using the `block` option. You can refer to the script file by name, or you can use a Liquid variable, for instance, obtained from the `page.files` array, or using the `match_file` filter.

{% preview %}
Here are lines 1-7 of `example.Rev`
{{ "example.Rev" | snippet:"line","1-7" }}

Here is the third block of text from `{{ page.files[1].name }}`
{{ page.files[1] | snippet:"block","3" }}

{% assign example_script = "example.Rev" | match_file %}

Here are the second and third blocks of text from `{{ example_script.name }}`
{{ example_script | snippet:"block#","2-3" }}
{% endpreview %}

{% section Formatting code %}

You can format code using the <code>```</code> or <code>~~~</code> fenced code delimiters. By default, tutorial code is formatted for Rev
{% preview %}
```
for (i in 1:n_branches) {
   br_lens[i] ~ dnExponential(10.0)
   moves[mvi++] = mvScale(br_lens[i]) 
}
```
{% endpreview %}

Code representing output from the Rev console can be formatted using the `{:.Rev-output}` class

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
grep phylogenetics tutorial.md
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

{% subsection Referencing equations %}

You can number and reference equations using the `\label`, `\tag` and `\ref` Latex commands.

{% preview %}
$$\begin{align}
\frac{(s-1)^b}{(s x + y)^{b+p}} &= \frac{1}{(s x +y)^p}\left(\frac{s-1}{s x + y}\right)^b \label{equation1}\tag{1} \\
&= \sum_{i=0}^b \binom{b}{i}(-1)^i \frac{(x+y)^i}{x^b(sx+y)^{i+p}} \label{equation2}\tag{2}
\end{align}$$

This is a reference to Equation $\ref{equation1}$. This is a reference to Equation $\ref{equation2}$.

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

Any Markdown file in your tutorial directory will be rendered as a separate tutorial as long as it has YAML front matter. For example, if we make a copy of the same external file (say `external_file-yaml.md`) and simply add an empty front matter section, then Jekyll will automatically generate [this page](external_file-yaml.html) when building the website.

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
├── new_tutorial.md <font color="red"><-- tutorial page (with front matter)</font>
└── v2.md           <font color="red"><-- tutorial page (with front matter)</font>
</pre>

In this example, there are two versions of the tutorial, both of which will get listed on the main {% page_ref tutorials %} page. If you do not want your tutorial listed in the [Tutorials]({{site.baseurl}}/tutorials/) index, use the `index: false` attribute in the YAML front matter.

{% subsection Linking to other tutorials | linking %}

You can reference another tutorial using the `page_ref` and `page_url` Liquid tags, or with the `match_page` filter. As with [Prerequisites](#including-prerequisites), tutorials can be referred to by any unique path identifier, ignoring `index.md` and `.md` suffixes.


{% preview %}
This is a reference to the {% page_ref intro %} tutorial.

{% assign var = "ctmc" %}
This how to link to the {% page_ref {{ var }} %} tutorial using a liquid variable,

{% assign tut = "clocks/simple" | match_page %}
This is how to retrieve the *{{ tut.title }}* tutorial page by name.

The relative URL of the `{{ var }}` tutorial is `{% page_url {{ var }} %}`.
{% endpreview %}

{% section Figures %}

Figures can be included from the `figures` subdirectory (or elsewhere) using the `figure` and `figcaption` Liquid tags. Figures are referenced using the `ref` Liquid tag.

{% preview %}
{% figure example %}
<img src="figures/example.png" width="200">
{% figcaption %}
This is an example figure caption. You can include *Markdown* and $\LaTeX$.
{% endfigcaption %}
{% endfigure %}
  
This is a reference to {% ref example %}
{% endpreview %}

{% section Tables %}

Table can be included in *Markdown* using the `table` and `tabcaption` Liquid tags. Tables are referenced using the `ref` Liquid tag.

{% preview %}

{% table exampletable %}
  |    Range    | Bits  | Size | State |
  |-------------|-------|------|-------|
  |$\emptyset$  |  000  |  0   |   0   |
  |A            |  100  |  1   |   1   |
  |B            |  010  |  1   |   2   |
  |C            |  001  |  1   |   3   |
  |AB           |  110  |  2   |   4   |
  |AC           |  101  |  2   |   5   |
  |BC           |  011  |  2   |   6   |
  |ABC          |  111  |  3   |   7   |

   {% tabcaption %}
    Example table caption
   {% endtabcaption %}
{% endtable %}
  
This is a reference to {% ref exampletable %}
{% endpreview %}

{% section Printing to PDF %}

You can prevent any element from being printed when the tutorial is sent to PDF or a printer by tagging it with `{:.no-print}`.

{% section Citations and bibliography %}

You can include a citation using the `cite` and `citet` Liquid tags.

{% preview %}
This is a citation {% cite Felsenstein1981 %}.  
This is an in-text citation of {% citet Felsenstein1981 %}.  
This is a citation with multiple sources {% cite Felsenstein1981 Hoehna2016b %}.
{% endpreview %}

Citations are included in the **References** section at the end of each tutorial. References are formatted according to the [CSL](https://github.com/citation-style-language/styles) style for [*Systematic Biology*](https://academic.oup.com/sysbio).

{% include bibliography.html %}


