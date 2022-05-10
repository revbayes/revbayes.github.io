---
layout: home
title: Compile on Linux
subtitle: Compile on Linux
permalink: /compile-linux
code_layout: bash
---

**NOTE: These instructions are for compiling the development branch.**

You can also [compile with meson](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md) instead of cmake.

## Pre-requisites

You will need to have a C++ compiler installed on your computer. GCC 6 (or higher) and Clang 8 (or higher) should work.

You will also need to have CMake (3.5.1 or higher) and Boost (1.71 or higher) installed

### Installing pre-requisites *with* root/administrator priveleges

Install these using your distribution's package manager

#### Ubuntu

    sudo apt install build-essential cmake libboost-all-dev

#### CentOS 8

    sudo yum group install "Development Tools"
    sudo yum install cmake boost-devel

### Installing pre-requisites on Linux computing clusters

If you are compiling revbayes on a Linux cluster, you might need to select a version of gcc or cmake that is more recent than the default version.

Most high-performance compute clusters have additional software available as "modules".
Using the `module avail` command followed by the name of the library will tell you if there is already a sufficiently recent version installed, thus saving you the effort of installing boost or cmake yourself:

    module avail
    module help gcc boost cmake
    module load gcc

CMake, GCC and Boost are all commonly used in computational research, there will likely be a sufficiently recent version of gcc and cmake, and perhaps a recent enough version of boost.

### Installing pre-requisites *without* root/administrator priveleges

If there is no compiler, you will need your administrator to install build-essential (or equivalent package containing gcc) for you. If possible, ask them to install cmake as well.

#### Installing cmake

The simplest way to [install cmake](https://cmake.org/install/) is to [download](https://cmake.org/download/) a CMake executable.  For example:

    curl -O -L https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.tar.gz
    tar -zxf cmake-3.22.1-linux-x86_64.tar.gz
    cmake-3.22.1/bin/cmake --version
    echo "cmake installed at: $(cd cmake-3.22.1/bin; pwd)/cmake"

Note the full path to the cmake executable!
You may replace the call to cmake on line 161 of `build.sh` with this path to use your custom cmake installation.

In the rare cases where the downloaded cmake executable will not run on your computer, you can also compile from source:

    curl -O -L https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz
    tar -xzvf cmake-3.22.1.tar.gz
    cd cmake-3.22.1/
    ./bootstrap -- -DCMAKE_USE_OPENSSL=OFF
    make
    bin/cmake --version
    echo "cmake installed at: $(cd bin; pwd)/cmake"

Note the full path to the cmake executable.

#### Installing boost

Then you can compile boost:

    curl -O -L https://boostorg.jfrog.io/artifactory/main/release/1.74.0/source/boost_1_74_0.tar.gz
    tar -xzvf boost_1_74_0.tar.gz
    cd boost_1_74_0
    ./bootstrap.sh --with-libraries=atomic,chrono,filesystem,system,regex,thread,date_time,program_options,math,serialization
    ./b2 link=static

When it is done, something like the following will be printed. You will need these paths for the next step.

>    The following directory should be added to compiler include paths:
>
>    /root/boost_1_74_0
>
>    The following directory should be added to linker library paths:
>
>    /root/boost_1_74_0/stage/lib

## Compile

Download RevBayes from our github repository. Clone the repository using git by running the following command in the terminal:

    git clone --branch development https://github.com/revbayes/revbayes.git revbayes

To compile with the system boost:

    cd revbayes/projects/cmake
    ./build.sh

You will likely see some compiler warnings. This is normal. 

To compile revbayes using a locally compiled boost, do the following. Be sure to replace the paths in the build command with those you got from boost in the previous step.

    ./build.sh -boost_root /root/boost_1_74_0 -boost_lib /root/boost_1_74_0/stage/lib

For the MPI version:

    ./build.sh -mpi true

This produces an executable called `rb-mpi`.

Note that compiling the MPI version requires that an MPI library is installed. If you have root, openmpi can be install with apt or yum. If not, if can be [downloaded](https://www.open-mpi.org/) and compiled.

## Troubleshooting

### General

* `rb: command not found`

    The problem is that you tried to run RevBayes but your computer doesn't know where the executable is. The easiest way is to add the directory in which you compiled RevBayes to your system path:

    ```
export PATH=<your_revbayes_directory>/projects/cmake:$PATH  
```

* `Error cmake not found!`  

   Please double check that CMake is installed.

### Boost

* `Error can't find the libboost_filesystem.so library or Library not   loaded: libboost_filesystem.so`

    You need to add the boost libraries to your path variable. You may find that you have to export this `LD_LIBRARY_PATH` every time you open a new terminal window. To get around this, you can add this to your `.bash_profile` or `.bashrc` file (which lives in your home directory). To change this, open a new terminal window and you should be in the home directory. If you do not have either of these files, use the text editor `nano` to create this file type:

    ```
cd ~
touch .bash_profile
nano .bash_profile
```

    Then add the following lines, replacing `/root` with wherever you put the boost libraries:

    ```
export LD_LIBRARY_PATH=/root/boost_1_74_0/stage/lib:$LD_LIBRARY_PATH
```

    Then save the file using ctrl^o and hit return, then exit using ctrl^x. Now quit the Terminal app and reopen it and the boost libraries will forever be in your path.


### MPI

* **I am using MPI RevBayes and receiving an ORTE transport error**

    This typically occurs if the version of MPI that is in your environment is not the same as the one you used to compile RevBayes. For example, if you compiled RevBayes
    with OpenMPI, but later installed Anaconda Python, which installs a Python MPI. If you receive this error, you might consider removing alternative MPI versions from your system path while running RevBayes. You can check which version of MPI you are using with the command `mpirun --version.` Note that you may want to remove the build directory before restarting your build.
