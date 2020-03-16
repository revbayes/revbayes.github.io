---
layout: home
title: Compile with Spack
subtitle: Compile with Spack
permalink: /compile-spack
code_layout: bash
---

## What is Spack?

[Spack](https://spack.readthedocs.io/en/latest/index.html) is a package management tool designed to support multiple versions and configurations of software on a wide variety of platforms and environments. It was designed for large supercomputing centers, where many users and application teams share common installations of software on clusters with exotic architectures, using libraries that do not have a standard ABI.

For RevBayes, it handles installing and linking the Boost and MPI dependencies for you. It also handles differences in the build process between versions of RevBayes.

## Pre-requisites

You will need to have C++ compiler installed on your computer, along with `git`, `make`, `curl`, and `python`. On OSX, [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) is required.

## Set up

```
git clone https://github.com/spack/spack.git
cd spack
./share/spack/setup-env.sh
spack compiler find
```

## Compile and Run

### Latest stable version

#### Without MPI
```
spack install revbayes ~mpi
spack load revbayes
rb
```

#### With MPI
```
spack install revbayes +mpi
spack load revbayes
mpirun rb-mpi
```

### Development version

Note: Due to build process changes on the development branch, this doesn't quite work yet. It will after [this pull request](https://github.com/spack/spack/pull/15485) is merged. This comment will be removed after that happens.

#### Without MPI
```
spack install revbayes@develop ~mpi
spack load revbayes
rb
```

#### With MPI
```
spack install revbayes@develop +mpi
spack load revbayes
mpirun rb-mpi
```

### Older version

You can install older versions by replacing `@develop` in the development version commands with `@version`. E.g. 

```
spack install revbayes@1.0.12 ~mpi`.
```

To get a list of available versions run:

```
spack info revbayes
```

## Troubleshooting

### `Error: revbayes@develop matches multiple packages.` 

The error message should have a list of of packages like so:


>     Matching packages:
>         abe2xnq revbayes@develop%gcc@9.2.1 arch=linux-fedora31-skylake
>         l6sv4oz revbayes@develop%gcc@9.2.1 arch=linux-fedora31-skylake

The text before `revbayes` in each line is the has for the package. You can get more information by doing `spack find --deps /hash`. E.g.

```
spack find --deps /abe2xnq
```

Which shows 

>      -- linux-fedora31-skylake / gcc@9.2.1 ---------------------------
>      revbayes@develop
>          boost@1.72.0
>              bzip2@1.0.8
>              zlib@1.2.11


```
spack find --deps /l6sv4oz
```

Which shows

>      ==> 1 installed package
>      -- linux-fedora31-skylake / gcc@9.2.1 ---------------------------
>      revbayes@develop
>          boost@1.72.0
>              bzip2@1.0.8
>              zlib@1.2.11
>          openmpi@3.1.5
>              hwloc@1.11.11
>                  libpciaccess@0.13.5
>                  libxml2@2.9.9
>                      libiconv@1.16
>                      xz@5.2.4
>                  numactl@2.0.12


The difference here is that l6sv4oz was compiled with mpi support.

We can load it with

```
spack load /l6sv4oz
```



