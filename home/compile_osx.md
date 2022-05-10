---
layout: home
title: Compile on Mac OS X
subtitle: Compile on Mac OS X
permalink: /compile-osx
code_layout: bash
---

**NOTE: These instructions are for compiling the development branch.**

You can also [compile with meson](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md) instead of cmake.

## Pre-requisites

You will need to have C++ compiler installed on your computer. GCC 6 (or higher) and Apple Clang from XCode 11 (or higher) should work. If you don't have a C++ compiler, you should install Xcode.

You will also need to have CMake (3.5.1 or higher) and Boost (1.74 or higher) installed

###  Installing pre-requisites *with* root/administrator priveleges (the usual case)

The typical way to install `boost` and `cmake` is to use the [homebrew](https://brew.sh/) package manager.
If homebrew is not already installed, you can install it with:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

You can then use homebrew to install cmake and boost:

    brew install cmake boost


### Installing pre-requisites *without* root/administrator priveleges

First you will need to [install cmake](https://cmake.org/install/)

Then you can compile boost:

    curl -O -L https://boostorg.jfrog.io/artifactory/main/release/1.74.0/source/boost_1_74_0.tar.gz
    tar -xzvf boost_1_74_0.tar.gz
    cd boost_1_74_0
    ./bootstrap.sh --with-libraries=atomic,chrono,filesystem,system,regex,thread,date_time,program_options,math,serialization --prefix=../installed-boost-1.74.0
    ./b2 link=static install
    echo -e "\n    BOOST root is at $(cd ../installed-boost-1.74.0; pwd)\n"

This creates a new directory called `installed-boost-1.74.0` that contains the boost installation.
This directory is called the BOOST "root".
You will need the path to the BOOST root for the next step.

To set up an IDE such as XCode, the following directory should be added to compiler include paths:

    /path/to/installed-boost-1.74.0/include

The following directory should be added to linker library paths:

    /path/to/installed-boost-1.74.0/lib

## Compile

Download RevBayes from our github repository. Clone the repository using git by running the following command in the terminal 

    git clone --branch development https://github.com/revbayes/revbayes.git revbayes

To compile with the system Boost library:

    cd revbayes/projects/cmake
    ./build.sh

You will likely see some compiler warnings (e.g. `clang: warning: optimization flag '-finline-functions' is not supported`). This is normal. 


To compile revbayes using a locally compiled boost, do the following. Be sure to replace the paths in the build command with those you got from boost in the previous step.

    ./build.sh -boost_root /path/to/installed-boost-1.74.0

For the MPI version:

    ./build.sh -mpi true

This produces an executable called `rb-mpi`.

Note that compiling the MPI version requires that an MPI library is installed.

## Troubleshooting

### General

* `rb: command not found`
    
    The problem is that you tried to run RevBayes but your computer doesn't know where the executable is. The easiest way is to add the directory in which you compiled RevBayes to your system path:

    ```
export PATH=<your_revbayes_directory>/projects/cmake:$PATH  
```

* `Error cmake not found!`  
   
   Please double check that CMake is installed. For OS X, go to step 2 above.

### Boost

* `Error can't find the libboost_filesystem.dylib library or Library not   loaded: libboost_filesystem.dylib` 
   
    You need to add the boost libraries to your path variable. You may find that you have to export this `DYLD_LIBRARY_PATH` every time you open a new terminal window. To get around this, you can add this to your `.bash_profile` or `.bashrc` file (which lives in your home directory). To change this, open a new terminal window and you should be in the home directory. If you do not have either of these files, use the text editor `nano` to create this file type:

    ```
cd ~
touch .bash_profile
nano .bash_profile
```

    Then add the following lines, replacing `/root` with wherever you put the boost libraries:

    ```
export DYLD_LIBRARY_PATH=/root/boost_1_74_0/stage/lib:$DYLD_LIBRARY_PATH
```

    Then save the file using ctrl^o and hit return, then exit using ctrl^x. Now quit the Terminal app and reopen it and the boost libraries will forever be in your path.
