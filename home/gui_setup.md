---
layout: home
title: Graphical User Interfaces
subtitle: Use RevBayes with a Graphical Interface
permalink: /gui-setup
code_layout: bash
---

{% section Graphical User Interfaces %}

There are two main graphical user interfaces (GUIs) that can be used with RevBayes. Below, installation instructions are listed for both.

{% section Jupyter Notebook %}

First, download and install Python 3 and the Jupyter Notebook. Installation instructions are available from the Jupyter Development team [here](https://jupyter.readthedocs.io/en/latest/install.html).


{% subsection RevBayes Downloads %}

{% subsubsection Using a Pre-Built RevBayes %}

RevBayes [pre-built executables](https://github.com/revbayes/revbayes/releases/tag/v1.2.2-preview1) are designed to work with Jupyter. You may want to ensures that `rb` executable can be found using the `which` command or be located using the environment variable, `REVBAYES_JUPYTER_EXECUTABLE`. For instance, you can set the environment variable using

```sh
export REVBAYES_JUPYTER_EXECUTABLE=<revbayes_path>/rb
```

{% subsubsection Compiling RevBayes %}

Now, use the [Downloads](https://revbayes.github.io/download) page to find RevBayes compilation instructions for your operating system. When building RevBayes, substitute

```
./build.sh -jupyter
```

for the normal build step. This will generate an `rb` executeable. Add this executable to your system path.

{% subsubsection Comnnect RevBayes and Jupyter %}


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


{% section RStudio %}

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
