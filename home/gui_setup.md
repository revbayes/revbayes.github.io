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


Now, use the [Downloads](https://revbayes.github.io/download) page to find RevBayes compilation instructions for your operating system. When building RevBayes, substitute

```
./build.sh -jupyter true
```

for the normal build step. This will generate an `rb-jupyter` executeable. Add this executeable to your system path.

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

Compile or download RevBayes as appropriate for your system above. Add RevBayes to your system path.

Download [R](https://cran.rstudio.com/) and [RStudio](https://rstudio.com/products/rstudio/download/). Once these are downloaded, start RStudio. Install the `remotes` package. We will also install the package `usethis` to aid with installation:

```
install.packages("remotes")
install.packages("usethis")
```

Use `remotes` to install RevKnitr:

```
remotes::install_github("revbayes/Revticulate")
```

Once installation is complete, type

```
library(Revticulate)
```

in a markdown chunk or in the console. This will prompt Revticulate to open your .Renviron file. You will use this to place the path to RevBayes in the Renviron, providing R with the location of RevBayes so that Revticulate may execute code using it. You will enter into the file the location of RevBayes on your hard drive. For example, if I have RevBayes installed in my software directory, this will be:

```
rb=/Users/software/rb
```

Now, you may use RevBayes in either KnitR or console. For examples of RevBayes used via Revticulate, see the [Revticulate website](https://paleantology.github.io/Revticulate/).
