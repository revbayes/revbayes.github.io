---
title: The TensorPhylo plugin
subtitle: Installing and using TensorPhylo and the Generalized Lineage-Heterogeneous Birth-Death-Sampling Process
authors: Michael May and Bruno do Rosario Petrucci
level: 7
order: 3.20
prerequisites:
- intro
- mcmc
- divrate/simple
- sse/bisse-intro
include_all: false
index: false
---

{% section Introduction | introduction %}

This tutorial describes the steps to download, compile, and install the TensorPhylo plugin {% cite May2024 %}, discusses its strengths and limitations, and
details the usage of the `dnGLHBDSP` function that uses the plugin. This function generalizes state-dependent speciation and extinction (SSE) and fossilized
birth-death (FBD) models, allowing for users to use it to set up any particular case of those models, e.g. BiSSE {% cite Maddison2007 %}, HiSSE {% cite Beaulieu 2016 %},
or FBD specimen {% cite Stadler2010 Heath2014 %}.

{% section Installation | installation %}

Note that all the steps described here can also be found in the 
[TensorPhylo installation page](https://bitbucket.org/mrmay/tensorphylo/src/a1314e61f180bd46a4de529bc6d26c434d1d442a/doc/Install.md).

{% subsection Linux and MacOS | unix %}

First, you must ensure you have access to all the command-line tools required by TensorPhylo. 
These can all be easily installed using your Linux package manager, or homebrew if you're using MacOS. They are:

- curl
- zip and unzip
- automake and autoconf
- make
- python 2

To begin installing TensorPhylo, first acquire it from [its BitBucket repository](https://bitbucket.org/mrmay/tensorphylo/src/master/). This could involve downloading it
from your browser and extracting it locally, or cloning it with `git`, similarly to how you cloned the RevBayes repository.

```
git clone https://bitbucket.org/mrmay/tensorphylo.git
```

Or, if you prefer using ssh

```
git clone git@bitbucket.org:mrmay/tensorphylo.git
```

Then, navigate to `tensorphylo/build/installer`, and execute the installation script by running

```
bash install.sh
```

This will take several minutes, and use several processors. Make sure not to have too much running at the same time.
The installation script will let you know if any dependency is missing. It will then download and compile eigen,
NCL, and boost locally, and install tensorphylo properly. Once done, all the TensorPhylo libraries will be in
`build/installer/lib`. If the installation is unsuccessful, a `build/installer/log.txt` file will be written.
If you can't understand what went wrong, submit an issue (including the `log.txt` file) in the BitBucket repository.

{% subsection Windows | windows %}

For the Windows installation, all you need to start is an internet connection (to download all necessary dependencies) and a functional installation
of [cygwin](https://www.cygwin.com/), a Unix-like terminal for Windows.

First, download TensorPhylo, in the same way described on the {% ref unix %} section. Then, copy the cygwin `setup-x86_64.exe` executable
into `tensorphylo/build/installer/cygwin`. Using a cygwin terminal, you can then install all necessary dependencies by running

```
cd build/installer/cygwin
bash installPackages.sh
```

Then, once all dependencies are installed, you can move back to `build/installer` and run

```
bash install.sh
```

This will take a while, possibly even a few hours, and use several processors. Make sure not to have too much
running in your computer at the same time. Once done, all the TensorPhylo libraries will be in `build/installer/lib`.
If the installation is unsuccessful, a `build/installer/log.txt` file will be written.
If you can't understand what went wrong, submit an issue (including the `log.txt` file) in the BitBucket repository.

{% section Using TensorPhylo | usage %}

Talk here about why TensorPhylo is good, and what kinds of applications it has that make it better than native revbayes functions

{% subsection The Generalized Lineage-Heterogeneous Birth-Death-Sampling Process distribution | glhbdsp %}

Describe `dnGLHBDSP`!

{% section Worked example using BiSSE | bisse %}

Quick example adapting the BiSSE tutorial to use `dnGLHBDSP`
