---
layout: home
title: Singularity
subtitle: Singularity 
permalink: /singularity/
---

## What is Singularity?

Singularity is a container runtime designed for use in HPC. 

Containers can run without root access on any Linux system with Singularity installed. 

[Singularity FAQ](https://sylabs.io/singularity/faq/)

Containers are immutable and directories are mounted to read or write from files. Some directories are mounted automatically when an image is run. [More information is available here](https://sylabs.io/guides/3.4/user-guide/quick_start.html#working-with-files).

## How do I install Singularity?

Installing Singularity requires root access to a Linux machine.

Your HPC system may already have it installed.

If not, your HPC staff can get it from a EPEL (CentOS/RHEL) or Debian/Ubuntu repostitory. [More information is available here.](https://sylabs.io/guides/3.4/user-guide/installation.html#distribution-packages-of-singularity)

## How to use the RevBayes image

First, download the image from the link on the Downloads page.

#### To get to an interative shell

```
singularity run --app rb RevBayes_Singularity_v1.0.13.simg 
```

#### To run a script file

```
singularity run --app rb RevBayes_Singularity_v1.0.13.simg myscript.rev
```

Any arguments after RevBayes_Singularity_v1.0.13.simg are passed to the rb command.

### MPI

The container also contains the MPI version of RevBayes. This version was built with the ubuntu-provided OpenMPI implementation (3.1.2) and may not work with other MPI versions.

To run a script file:
```
mpirun singularity run --app rbmpi RevBayes_Singularity_v1.0.13.simg myscript.rev
```

If it does not work with the version of MPI you have on your cluster, you could ask your administrator to rebuild the image for the appropriate MPI version for your environment (see recipe below). [More information is available here](https://sylabs.io/guides/3.4/user-guide/mpi.html).

### Recipe

Here is the recipe that was used to build the v1.0.13 version of the container image.

```text
BootStrap: library
From: ubuntu:latest

%post

    mkdir /revbayes
    
    echo "Installing required packages..."
    
    # revbayes dependencies
    apt-get update -y
    apt-get install -y build-essential bash-completion git cmake

    # install boost
    apt-get install -y software-properties-common
    add-apt-repository universe
    apt-get update -y
    apt-get install -y libboost-all-dev

    # download revbayes
    git clone https://github.com/revbayes/revbayes.git /revbayes-build
    cd /revbayes-build
    git checkout 9afdfe377eaffe0dea467b2ce5520fb055c14563

%environment
    export PATH=$PATH:/revbayes

%runscript
    exec rb $@

%appinstall rb
    cd /revbayes-build/projects/cmake/
    rm -rf build
    ./build.sh
    mv rb /revbayes/rb

%apprun rb
    exec rb $@

%appinstall rbmpi

    apt-get install -y libopenmpi-dev
    cd /revbayes-build/projects/cmake/
    rm -rf build
    ./build.sh -mpi true
    mv rb /revbayes/rb-mpi

%apprun rbmpi
    exec rb-mpi $@
```