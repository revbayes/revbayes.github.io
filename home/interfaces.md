---
layout: home
title: Interfaces
subtitle: Tools for Interacting with RevBayes
permalink: /interfaces
---

{% section  The Rev Language %}

In practice, most researchers will primarily work with RevBayes by writing scripts in the Rev language and executing these directly. Most of the [tutorials]({% page_url tutorials %}) demonstrate this approach to RevBayes analysis. In the [Documentation]({% page_url documentation %}), you will find the Rev Language Reference that will allow you to browse the various components of Rev and their associated documentation. If you use RevBayes interactively in your terminal, you can also access Rev language documentation using the `?` object. For example, typing `?dnPoisson` will output a description and usage details of the Poisson distribution function. This is the same information provided on the Poisson distribution help page: [https://revbayes.github.io/documentation/dnPoisson.html](https://revbayes.github.io/documentation/dnPoisson.html).

{% section  Graphical User Interfaces %}

Within the RevBayes project we are developing alternative interfaces for specifying RevBayes models and analyses. These are intended to provide more interactive workflows using different interface styles. Note that some of these projects are still under active development and may not be fully functional. 
* {% ref jupyternb %}: specify and execute analyses using the Rev language in a notebook interface
* {% ref rstudio %}: create Rev scripts for execution in RevBayes using R and RStudio
* {% ref revscripter %}: an introductory, menu-driven GUI for generating Rev scripts for a subset of analyses (in development)
* {% ref macgui %}: an interactive macOS GUI for creating analysis workflows and models for RevBayes (in development)


{% subsection Jupyter Notebook | jupyternb %}

{% subsubsection Get Python3 and Jupyter Notebook %}

First, download and install Python 3 and the Jupyter Notebook.
Installation instructions are available from the Jupyter Development team [here](https://jupyter.readthedocs.io/en/latest/install.html).


{% subsubsection Get RevBayes %}


RevBayes [pre-built executables](https://github.com/revbayes/revbayes/releases/) are designed to work with Jupyter. You may want to ensures that `rb` executable can be found using the `which` command or be located using the environment variable, `REVBAYES_JUPYTER_EXECUTABLE`. For instance, you can set the environment variable using

```sh
export REVBAYES_JUPYTER_EXECUTABLE=<revbayes_path>/rb
```

{% subsubsection Connect RevBayes and Jupyter %}


Finally, clone the RevBayes Jupyter Kernel.

```
git clone https://github.com/revbayes/revbayes_kernel.git
```

Change directories into the `revbayes_kernel` directory and use

```
sudo python3 setup.py install
python3 -m revbayes_kernel.install
pip3 install metakernel
```
to deploy the kernel. Now, when launching a Jupyter Notebook, RevBayes should be an available language when starting a notebook. You can check the installation by executing the revbayes_mcmc_demo.ipynb found in the `revbayes_kernel` directory.

Examples of RevNotebooks can be found in the RevNotebook [repository](https://github.com/revbayes/RevNotebooks).


{% subsection RStudio | rstudio %}

Compile or download RevBayes as appropriate for your system above. Note where on your computer it is stored.

Download [R](https://cran.rstudio.com/) and [RStudio](https://rstudio.com/products/rstudio/download/). Once these are downloaded, start RStudio. Install the `remotes` package. We will also install the package `usethis` to aid with installation:

```
install.packages("remotes")
install.packages("usethis")
```

RStudio does not run RevBayes by default, as RevBayes is a separate piece of software from R or RStudio. Use `remotes` to install Revticulate, an R package for using RevBayes within R and RStudio environments:

```
remotes::install_github("revbayes/Revticulate")
```

Once installation is complete, type into an RMarkdown cell:

```
library(Revticulate)
knitRev()
```

When you execute the above, Revticulate will run a package check.
This check searches for and .Renviron file that contains a RevBayes path. If the package doesn’t find this file, or finds it without the path, the package prompts the user to use `usethis::edit_r_environ()`. This opens the .Renviron file, and the user will enter `rb={absolute path to revbayes}`. This can be edited at any time if there are multiple installs on the system, or if you recompile RevBayes and want to use a new version.

Now, you may use RevBayes in either KnitR or console. For examples of RevBayes used via Revticulate, see the [Revticulate website](https://paleantology.github.io/Revticulate/) and our tutorial on [setting up RevBayes](https://revbayes.github.io/tutorials/tutorial_structure/).

{% subsection RevScripter | revscripter %}

RevScripter is a web-based tool that enables researchers to create scripts describing phylogenetic models and analyses in the Rev language. These script files then can be executed in the program RevBayes. RevScripter is intended to serve as an introductory tool that guides new users through the setup for a subset of phylogenetic analyses. 

<a href="https://revbayes.github.io/revscripter/" class="btn btn-primary" role="button">RevScripter</a>

Currently, the options available in RevScripter are limited and the tool is still very much in development. The tool can create scripts for running an unrooted analysis using nucleotide data under standard substitution models. For more details about the available models and analyses, please see the README file in the RevScripter source repository: [https://github.com/revbayes/revscripter](https://github.com/revbayes/revscripter).

{% subsection RevBayes macOS GUI | macgui %}

The RevBayes macOS GUI is an interactive graphical user interface for RevBayes written in Swift with the use of Cocoa libraries that runs on the macOS platform.

The complexity of the RevBayes program and the Rev language can be a significant barrier to the scientists wanting to use the program. It is the goal of the RevBayes GUI project to overcome that barrier. RevBayes GUI serves to simplify the use of RevBayes while at the same time expose its full functionality.

RevBayes GUI is a document-based application, with a collection of phylogenetic analyses seen as a document. The user can create an analysis by dragging the necessary components from a tool palette and dropping them on the analysis canvas. Adopting a convention from the field of graphical models in computer science, we allow a biologist specify their analysis as a graph. We use a tool metaphor to expose the functionality of the program. Each node in the graph is a tool that carries out a single task, such as reading and visualizing data from a file, setting the phylogenetic model graphically, aligning DNA sequences, etc. Tool Model, often the core of an analysis, allows the user to specify their model assumptions. Like with the analysis, RevBayes GUI exposes a model as a graph. The user can build up models graphically, by bringing together different mathematical components of a model just as a child would build a house out of Lego bricks.

Development of RevBayes GUI is funded by an NSF grant. It is an open-source project on GitHub. The <a href="https://github.com/svetakrasikova/macgui">GitHub repository</a> can be freely cloned.

If you would like to contribute to the project or report issues please contact the <a href="https://github.com/svetakrasikova">lead developer</a> to request access.

