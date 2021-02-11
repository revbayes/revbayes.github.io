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

## How do I install the Singularity runtime?

Installing the Singularity runtime requires root access to a Linux machine.

Your HPC system may already have it installed.

If not, your HPC staff can get it from a EPEL (CentOS/RHEL) or a Debian/Ubuntu repository. [More information is available here.](https://sylabs.io/guides/3.4/user-guide/installation.html#distribution-packages-of-singularity)

## How to use the RevBayes image

First, download the RevBayes Singularity image. [RevBayes_Singularity_1.1.1.simg](https://github.com/revbayes/revbayes/releases/download/{{ site.version }}/RevBayes_Singularity_{{ site.version }}.simg).

#### To get to an interative shell

```
singularity run --app rb RevBayes_Singularity_{{ site.version }}.simg 
```

#### To run a script file

```
singularity run --app rb RevBayes_Singularity_{{ site.version }}.simg myscript.rev
```

Any arguments after RevBayes_Singularity_{{ site.version }}.simg are passed to the rb command.

### MPI

The container also contains the MPI version of RevBayes. This version was built with the ubuntu-provided OpenMPI implementation (3.1.3) and may not work with other MPI versions.

To run a script file:
```
mpirun singularity run --app rbmpi RevBayes_Singularity_{{ site.version }}.simg myscript.rev
```

If it does not work with the version of MPI you have on your cluster, you could ask your administrator to rebuild the image for the appropriate MPI version for your environment (see recipe below). [More information is available here](https://sylabs.io/guides/3.4/user-guide/mpi.html).

### Recipe

Here is the recipe that was used to build the 1.1.1 version of the container image.

https://github.com/revbayes/revbayes/blob/singularity/projects/singularity/Singularity
