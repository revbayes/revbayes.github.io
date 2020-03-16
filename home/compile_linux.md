---
layout: home
title: Compile on Linux
subtitle: Compile on Linux
permalink: /compile-linux
code_layout: bash
---

** NOTE: These instructions are for compiling the development branch. **

The standard way to build revbayes is to use `cmake`.  If you want to compile using `meson`, see [revbayes/projects/meson/README.md](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md).

## Pre-requisites

First you will need to install gcc, cmake and boost

### If you have root

Install these using your distribution's package manager

#### Ubuntu

    sudo apt install build-essential cmake libboost-all-dev

#### CentOS 8

    sudo yum group install "Development Tools"
    sudo yum install cmake boost-devel

### If you do not have root

You will need your administrator to install build-essential (or equivalent package containing gcc) for you. If possible, ask them to install cmake as well.

If you need to compile CMake yourself:

    curl -O -L https://github.com/Kitware/CMake/releases/download/v3.17.0-rc3/cmake-3.17.0-rc3.tar.gz
    tar -xzvf cmake-3.17.0-rc3.tar.gz
    cd cmake-3.17.0-rc3/
    ./configure
    make

When this is completed, you will notice that there is now a `/bin` directory in the cmake directory. This contains the cmake executable. You may replace the call to cmake on line 45 of `build.sh` with this path to use your custom cmake installation.

Then you can compile boost:

    curl -O -L https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz
    tar -xzvf boost_1_71_0.tar.gz
    cd boost_1_71_0
    ./bootstrap.sh --with-libraries=atomic,chrono,filesystem,system,regex,thread,date_time,program_options,math,serialization
    ./b2 link=static

When it is done, something like the following will be printed. You will need these paths for the next step.

>    The following directory should be added to compiler include paths:
>
>    /root/boost_1_71_0
>
>    The following directory should be added to linker library paths:
>
>    /root/boost_1_71_0/stage/lib

## Compile

Then obtain the source:

    git clone https://github.com/revbayes/revbayes.git revbayes

To compile with system boost:

    cd revbayes/projects/cmake
    ./build.sh

To compile with a locally compiled boost, do the following. Be sure to replace the paths in the build command with those you got from boost in the previous step.

    cd revbayes/projects/cmake
    ./build.sh -boost_root /root/boost_1_71_0 -boost_lib /root/boost_1_71_0/stage/lib

For the MPI version:

    ./build.sh -mpi true

Note that to compile the MPI version requires that an MPI library is installed. If you have root, openmpi can be install with apt or yum. If not, if can be [downloaded](https://www.open-mpi.org/) and compiled.

## A note on compiling RevBayes on high-performance compute clusters

Most high-performance compute clusters have software available as "modules". Cmake, GCC and boost are all commonly used in computational research. Using the `module avail` command followed by the name of the library will tell you if there is already a version installed, thus saving you the effort of performing these steps yourself.

## Troubleshooting

* `rb: command not found`

    The problem is that you tried to run RevBayes but your computer doesn't know where the executable is. The easiest way is to add the directory in which you compiled RevBayes to your system path:

    ```
export PATH=<your_revbayes_directory>/projects/cmake:$PATH  
```

* `Error cmake not found!`  

   Please double check that CMake is installed.

* `Error can't find the libboost_filesystem.so library or Library not   loaded: libboost_filesystem.so`

    You need to add the boost libraries to your path variable. You may find that you have to export this `LD_LIBRARY_PATH` every time you open a new terminal window. To get around this, you can add this to your `.bash_profile` or `.bashrc` file (which lives in your home directory). To change this, open a new terminal window and you should be in the home directory. If you do not have either of these files, use the text editor `nano` to create this file type:

    ```
cd ~
touch .bash_profile
nano .bash_profile
```

    Then add the following lines, replacing `<your-revbayes-directory>` with wherever you put the Revbayes Github repository:

    ```
export LD_LIBRARY_PATH=<your-revbayes-directory>/boost_1_60_0/stage/lib:$LD_LIBRARY_PATH
export PATH=<your-revbayes-directory>/projects/cmake:$PATH  
```

    Then save the file using ctrl^o and hit return, then exit using ctrl^x. Now quit the Terminal app and reopen it and the boost libraries will forever be in your path.


* **I am using precompiled boost and getting messages like `undefined reference to boost::program_options` during the link step**

    It's possible that the boost you are using was compiled with an older version of GCC than the one you are trying to use to compile RevBayes. [GCC switched the default ABI in newer versions](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html). Try running:

    ```
    export CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"
    ```

    and then run build.sh again. If this does not fix the issue, you may consider recompiling boost with your current version of GCC.

* **I am using MPI RevBayes and receiving an ORTE transport error**

    This typically occurs if the version of MPI that is in your environment is not the same as the one you used to compile RevBayes. For example, if you compiled RevBayes
    with OpenMPI, but later installed Anaconda Python, which installs a Python MPI. If you receive this error, you might consider removing alternative MPI versions from your system path while running RevBayes. You can check which version of MPI you are using with the command `mpirun --version.` Note that you may want to remove the build directory before restarting your build.
