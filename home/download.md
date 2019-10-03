---
layout: home
title: Download
subtitle: Download and Install RevBayes
permalink: /download
code_layout: bash
---
<div class="row">

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/apple.png %}" alt="" width="100px" />
<h2>Mac OS X</h2>
<a href="https://github.com/revbayes/revbayes/releases/download/v1.0.13/RevBayes_OSX_v1.0.13.zip" class="btn btn-info" role="button">Download Executable (10.6+)</a>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/windows.png %}" alt="" width="100px" />
<h2>Windows</h2>
<a href="https://github.com/revbayes/revbayes/releases/download/v1.0.13/RevBayes_Win_v1.0.13.zip" class="btn btn-info" role="button">Download Executable (10)</a>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/tux.png %}" alt="" width="100px" />
<h2>Linux</h2>
<p>Compile from source</p>
</div>

</div>

<br>


## Compiling from source
----

The standard way to build revbayes is to use `cmake`.  If you want to compile using `meson`, see [revbayes/projects/meson/README.md](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md).

### Linux

#### If you have root

First you need to install cmake and boost:

    sudo apt install build-essential cmake libboost-all-dev

Then obtain the source and compile:

    git clone https://github.com/revbayes/revbayes.git revbayes
    cd revbayes/projects/cmake
    ./build.sh

For the MPI version:

    ./build.sh -mpi true

<br>

#### If you do not have root

You will need your administrator to install build-essential and cmake for you.

Then you can compile boost:

    curl -O -L https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz
    tar -xzvf boost_1_71_0.tar.gz
    cd boost_1_71_0.tar.gz
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

Now obtain the source for revbayes and compile. Be sure to replace the paths in the last command with those you got from boost in the previous step.

    git clone https://github.com/revbayes/revbayes.git revbayes
    cd revbayes/projects/cmake
    ./build.sh -boost_root /root/boost_1_71_0 -boost_lib /root/boost_1_71_0/stage/lib

<br>

### Mac OS X

1. Make sure that you have a C++ compiler installed on your computer. GCC 4.2 (or higher) and Apple LLVM version 6.0 have both been used successfully. If you don't have a C++ compiler, you should install Xcode.

2. Make sure that you have CMake and Boost installed. One option to install them is using homebrew:

    ``` 
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install cmake boost
```

3. Download RevBayes from our github repository. Clone the repository using git by running the following command in the terminal 

    ``` 
git clone https://github.com/revbayes/revbayes.git revbayes
```

4. Open a terminal and go to the RevBayes cmake directory:

    ```  
cd revbayes/projects/cmake
```

5. Now either build the standard version using the following:

    ``` 
./build.sh
```

    or build the MPI version to produce the rb-mpi executeable:

    ``` 
./build.sh -mpi true
```

    You will likely see some compiler warnings (e.g. `clang: warning: optimization flag '-finline-functions' is not supported`). This is normal. 

<br>

### Windows 10


1. Download and install 64-bit cygwin (setup-x86_64.exe). Make sure you include the following packages:

    (Cygwin package versions are from 9/2019. Newer versions may work, but see special version notes below)

    | package                 | version   | 
    |-------------------------|-----------| 
    | cmake                   | 3.14.5-1  | 
    | cmake-debuginfo         | 3.14.5-1  | 
    | cmake-doc               | 3.14.5-1  | 
    | cmake-gui               | 3.14.5-1  | 
    | git                     | 2.21.0-1  | 
    | make                    | 4.2.1-2   | 
    | mingw64-x86_64-boost    | 1.66.0-1  | 
    | mingw64-x86_64-gcc-core | 7.4.0-1   | 
    | mingw64-x86_64-gcc-g++  | 7.4.0-1   | 


    For RevStudio you will also need:

    | package                      | version   | 
    |------------------------------|-----------| 
    | mingw64-x86_64-atk1.0        | 2.26.1-1  | 
    | mingw64-x86_64-bzip2         | 1.0.6-4   | 
    | mingw64-x86_64-cairo         | 1.14.12-1 | 
    | mingw64-x86_64-fribidi       | 0.19.7-1  | 
    | mingw64-x86_64-gdk-pixbuf2.0 | 2.36.11-1 | 
    | mingw64-x86_64-glib2.0       | 2.54.3-1  | 
    | mingw64-x86_64-gtk2.0        | 2.24.31-1 | 
    | mingw64-x86_64-gtkmm2.4      | 2.24.5-1  | 
    | mingw64-x86_64-pango1.0      | 1.40.14-1 | 


    **Notes about the versions:**

    **Boost and CMake:**

    It's important that the version of Boost that you use be supported by the version of CMake that you use. You can check this by going to the package source for the CMake version you're using e.g. [3.14.5](https://github.com/Kitware/CMake/blob/v3.14.5/Modules/FindBoost.cmake). Search for `_Boost_KNOWN_VERSIONS` and ensure your boost version appears in the list.

2. Retrieve the RevBayes sources.

    1. Open a cygwin terminal window
    2. Clone the git repository:
        ```
        git clone https://github.com/revbayes/revbayes.git revbayes-master
        ```

3. Compile RevBayes.

    1. Open a cygwin terminal window and go to the RevBayes source directory if you haven't already done so, e.g., 
        ```
        cd revbayes-master
        ```
    2. Next, go into the projects and then the cmake subdirectory: 
        ```
        cd projects/cmake
        ```
    3. Now you can either build the standard version
        ```
        bash build-win.sh
        ```
        or the RevStudio version
        ```
        bash build-win.sh -cmd true
        ```

4. Library whack-a-mole

    When you try to run the executable you will likely get an error about missing libraries. 

    Make a new directory and put the executable in it. 

    Then find the library from the error message in `/usr/x86_64-w64-mingw32/sys-root/mingw/bin/` and copy it to the directory you put the exectuable in. Repeat this until you stop getting error messages. 

    At the time this was written (RevBayes v1.0.11), this consisted of:

    * iconv.dll
    * libatk-1.0-0.dll
    * libbz2-1.dll
    * libcairo-2.dll
    * libexpat-1.dll
    * libffi-6.dll
    * libfontconfig-1.dll
    * libfreetype-6.dll
    * libgcc_s_seh-1.dll
    * libgdk_pixbuf-2.0-0.dll
    * libgdk-win32-2.0-0.dll
    * libgio-2.0-0.dll
    * libglib-2.0-0.dll
    * libgmodule-2.0-0.dll
    * libgobject-2.0-0.dll
    * libgtk-win32-2.0-0.dll
    * libharfbuzz-0.dll
    * libintl-8.dll
    * libpango-1.0-0.dll
    * libpangocairo-1.0-0.dll
    * libpangoft2-1.0-0.dll
    * libpangowin32-1.0-0.dll
    * libpcre-1.dll
    * libpixman-1-0.dll
    * libpng16-16.dll
    * libstdc++-6.dll
    * libwinpthread-1.dll
    * zlib1.dll

<br>

### Troubleshooting

* `rb: command not found`
    
    The problem is that you tried to run RevBayes but your computer doesn't know where the executable is. The easiest way is to add the directory in which you compiled RevBayes to your system path:

    ```
export PATH=<your_revbayes_directory>/projects/cmake:$PATH  
```

* `Error cmake not found!`  
   
   Please double check that CMake is installed. For OS X, go to step 2 above.

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

