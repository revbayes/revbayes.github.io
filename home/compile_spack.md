---
layout: home
title: Compile with Spack
subtitle: Compile with Spack
permalink: /compile-spack
code_layout: bash
---

Works on OSX and Linux.

Note: The instructions below will compile version 1.0.13. It is possible to compile the development branch with spack, but the spack package currently needs updated to reflect changes to the build process on the development branch. This page will be updated soon after that is complete.

## Compile and run without MPI

```
git clone https://github.com/spack/spack.git
cd spack/bin
./spack compiler find
./spack install revbayes ~mpi
./spack load revbayes
rb
```

## Compile and run with MPI

```
git clone https://github.com/spack/spack.git
cd spack/bin
./spack compiler find
./spack install revbayes +mpi
./spack load revbayes
rb
```