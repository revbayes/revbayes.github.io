---
layout: home
title: Compile with Spack
subtitle: Compile with Spack
permalink: /compile-spack
code_layout: bash
---

## What is Spack?

[Spack](https://spack.readthedocs.io/en/latest/index.html) is a package management tool designed to support multiple versions and configurations of software on a wide variety of platforms and environments. It was designed for large supercomputing centers, where many users and application teams share common installations of software on clusters with exotic architectures, using libraries that do not have a standard ABI.

For RevBayes, it handles installing and linking the Boost and MPI dependencies for you. It also handles differences in the build process between versions.

## Pre-requisites

You will need to have C++ compiler installed on your computer, along with `git`, `make`, `curl`, and `python`. On OSX, [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) is required.

## Set up

```
git clone https://github.com/spack/spack.git
cd spack
source share/spack/setup-env.sh
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
spack install revbayes@1.0.12 ~mpi.
```

To get a list of available versions run:

```
spack info revbayes
```

## Troubleshooting

### Error: revbayes@develop matches multiple packages.

The error message should have a list of of packages like so:

<pre>
Matching packages:
    abe2xnq revbayes@develop%gcc@9.2.1 arch=linux-fedora31-skylake
    l6sv4oz revbayes@develop%gcc@9.2.1 arch=linux-fedora31-skylake
</pre>

The text before `revbayes` in each line is the hash for the package. You can get more information on the difference between the two packages by doing:

Package 1:

```
spack find --deps /abe2xnq
```

Which shows 

<pre>
-- linux-fedora31-skylake / gcc@9.2.1 ---------------------------
revbayes@develop
    boost@1.72.0
        bzip2@1.0.8
        zlib@1.2.11
</pre>

Package 2:

```
spack find --deps /l6sv4oz
```

Which shows

<pre>
==> 1 installed package
-- linux-fedora31-skylake / gcc@9.2.1 ---------------------------
revbayes@develop
    boost@1.72.0
        bzip2@1.0.8
        zlib@1.2.11
    openmpi@3.1.5
        hwloc@1.11.11
            libpciaccess@0.13.5
            libxml2@2.9.9
                libiconv@1.16
                xz@5.2.4
            numactl@2.0.12
</pre>

The difference here is that l6sv4oz was compiled with mpi support.

We can load it with

```
spack load /l6sv4oz
```