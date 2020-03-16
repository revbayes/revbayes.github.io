---
layout: home
title: Compile on Windows
subtitle: Compile on Windows
permalink: /compile-windows
code_layout: bash
---

** NOTE: These instructions are for compiling the master branch. **

The standard way to build revbayes is to use `cmake`. Cross-compiling for Windows from Linux is also possible using `meson`, see [revbayes/projects/meson/README.md](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md).

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
