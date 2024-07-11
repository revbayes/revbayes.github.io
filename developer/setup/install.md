---
title: Installing RevBayes from source
order: 0
---

Visual Studio Code (or VSCode) is an open-source text editor by Microsoft. You can download and install it <a href="https://code.visualstudio.com/Download">here</a>. 

Prerequisites
----------------------
Before getting started, Windows users will need to install the Boost libraries.

1. [Download Boost](https://www.boost.org/users/download/) and unzip the archive.  In this tutorial, I unzipped v1.85.0 to `c:\boost\boost_1_85_0`.
2. Download [b2 5.2.0](https://github.com/bfgroup/b2/releases) or above.  b2 v5.1.0, bundled with Boost 1.85, is [not compatible](https://github.com/conan-io/conan/issues/16465) with msvc-14.3.
2. Use a terminal (e.g. the cmd Command Prompt) " to `cd` to the boost directory, here: `c:/boost/boost_1_85_0`
3. Type `bootstrap.bat gcc` to run the script with gcc options.

Make sure you use the toolset you use matches the compiler you will employ in
VSCode; we assume gcc.

4. Remove (or rename) the local copy of `b2.exe`, so the system uses the updated version installed globally above.
4. Run `b2 --version` to confirm that a version of b2 >= 5.2 is available
6. Execute `b2 address-model=64 architecture=x86 toolset=gcc --build-dir=build --build-type=complete --prefix=c:/boost/boost_1_85_0/gcc --with-regex --with-program_options --with-thread --with-system --with-filesystem --with-date_time --with-serialization  install`.  You may need to update the `address-model=64 architecture=x86 toolset=gcc` options to match the configuration of your system - here, a 64-bit x86 machine.
5. Check that installation was successful.  If it was, `C:\boost\boost_1_85_0\gcc\lib\cmake\Boost-1.85.0` will contain a file `BoostConfig.cmake`

Now you will need to update the copy of CMakeLists.txt to tell the compiler how
Boost was compiled.

6. After the line `project(RevBayes)`, add:

`set(Boost_COMPILER "-mgw13")`
`set(BOOST_ROOT "C:/boost/boost_1_85_0/gcc")` (to match the value specified to b2 in the `prefix` argument)

7?. Also add `set(BOOST_LIBRARYDIR "C:/boost/boost_1_85_0/")` and, around line 170, `include_directories(${Boost_INCLUDE_DIRS})`
