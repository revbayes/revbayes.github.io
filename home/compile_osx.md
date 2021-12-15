---
layout: home
title: Compile on Mac OS X
subtitle: Compile on Mac OS X
permalink: /compile-osx
code_layout: bash
---

**NOTE: These instructions are for compiling the development branch.**

The standard way to build revbayes is to use `cmake`.  If you want to compile using `meson`, see [revbayes/projects/meson/README.md](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md).

## Pre-requisites

You will need to have C++ compiler installed on your computer. GCC 6 (or higher) and Apple Clang from XCode 11 (or higher) should work. If you don't have a C++ compiler, you should install Xcode.

You will also need to have CMake (3.5.1 or higher) and Boost (1.74 or higher) installed

### If you have root

One option to install them is using homebrew:

``` 
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install cmake boost
```

### If you do not have root

First you will need to [install cmake](https://cmake.org/install/)

Then you can compile boost:

    curl -O -L https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz
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

Download RevBayes from our github repository. Clone the repository using git by running the following command in the terminal 

``` 
git clone --branch development https://github.com/revbayes/revbayes.git revbayes
```

Open a terminal and go to the RevBayes cmake directory:

```  
cd revbayes/projects/cmake
```

Now either build the standard version using the following:

``` 
./build.sh
```

or build the MPI version to produce the rb-mpi executeable:

``` 
./build.sh -mpi true
```

To compile with a locally compiled boost, do the following. Be sure to replace the paths in the build command with those you got from boost in the previous step.

```
./build.sh -boost_root /root/boost_1_74_0 -boost_lib /root/boost_1_74_0/stage/lib
```

You will likely see some compiler warnings (e.g. `clang: warning: optimization flag '-finline-functions' is not supported`). This is normal. 

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

    Then add the following lines, replacing `<your-revbayes-directory>` with wherever you put the Revbayes Github repository:

    ```
export DYLD_LIBRARY_PATH=<your-revbayes-directory>/boost_1_60_0/stage/lib:$DYLD_LIBRARY_PATH
export PATH=<your-revbayes-directory>/projects/cmake:$PATH  
```

    Then save the file using ctrl^o and hit return, then exit using ctrl^x. Now quit the Terminal app and reopen it and the boost libraries will forever be in your path.


* **I am using precompiled boost and getting messages like `undefined reference to boost::program_options` during the link step**

    It's possible that the boost you are using was compiled with an older version of GCC than the one you are trying to use to compile RevBayes. [GCC switched the default ABI in newer versions](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html). Try running:

    ```
    export CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"
    ```

    and then run build.sh again
    
