---
layout: home
title: Compile on Windows
subtitle: Compile on Windows
permalink: /compile-windows
code_layout: bash
---

**NOTE: These instructions are for compiling the development branch.**

**NOTE: Boost now needs to be at least version 1.71.**

You can also [compile with meson](https://github.com/revbayes/revbayes/blob/development/projects/meson/README.md) instead of cmake.  Meson allows using linux to generate windows binaries ("cross-compiling").

1. Download and install 64-bit cygwin (setup-x86_64.exe). Make sure you include the following packages:

    (Cygwin package versions are from May 2022. Newer versions may work, but see special version notes below.  As of July 2024, RevBayes requires cmake 3.15 and Boost 1.71.)

    | package                 | version   | 
    |-------------------------|-----------| 
    | cmake                   | 3.14.5-1  | 
    | cmake-debuginfo         | 3.14.5-1  | 
    | cmake-doc               | 3.14.5-1  | 
    | cmake-gui               | 3.14.5-1  | 
    | git                     | 2.21.0-1  | 
    | make                    | 4.3-1     | 
    | mingw64-x86_64-boost    | 1.66.0-1  | 
    | mingw64-x86_64-gcc-core | 9.2.0-2   | 
    | mingw64-x86_64-gcc-g++  | 9.2.0-2   | 


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
    
    Occasionally, RevBayes may require a version of cmake or Boost that is not available via Cygwin.
    Once you have used Cygwin to install gcc, you can install these separately.
    
    [cmake](https://cmake.org/download) has a simple and well-documented installation pathway.
    
    Configuring [Boost](https://www.boost.org/) is less straightforward.
    
    1. [Download Boost](https://www.boost.org/users/download/) and unzip the archive.  In this tutorial, I unzipped v1.82.0 to `c:\boost\boost_1_82_0`.  It may be wise not to use the most current version; at time of writing, the latest 1.85 release caused compatibility issues.
    2. Use Open a cygwin terminal window and `cd` to the boost directory, here: `c:/boost/boost_1_82_0`
    3. Type `./bootstrap.bat gcc` to run the script with the gcc toolset.
    4. Execute `b2 toolset=gcc-13 address-model=64 architecture=x86 --build-dir=build variant=release --build-type=complete --prefix=c:/boost/boost_1_82_0/gcc --with-regex --with-program_options --with-thread --with-system --with-filesystem --with-date_time --with-serialization  install`.
       - The `address-model=64 architecture=x86 toolset=gcc-13` options are assumed to match the configuration of your system – here, a 64-bit x86 machine – throughout this tutorial.  Use `gcc -v` to check which version of gcc you are using and update `gcc-13` to match.
    5. Check that installation was successful.  If it was, `C:\boost\boost_1_82_0\gcc\lib\cmake\Boost-1.82.0` will contain a file `BoostConfig.cmake`
    
    If you see errors, you may need to use a more recent version of b2 than is bundled with Boost:
    - Download [b2 5.2.0](https://github.com/bfgroup/b2/releases) or above.
    - Remove (or rename) the local copy of `b2.exe`, so the system uses the updated version installed globally above.
    - Run `b2 --version` to confirm that a version of b2 >= 5.2 is available.
    
    6. Update `<path/to/revbayes>/src/CMakeLists.txt` to point to Boost:
      a. After the line `project(RevBayes)`, add:
         `set(BOOST_ROOT "C:/boost/boost_1_82_0/gcc")` 
         (to match the value specified to b2 in the `prefix` argument)
      b. After the  line starting `find_package(Boost`, around line 170,
         add `include_directories(${Boost_INCLUDE_DIRS})`
      c. Close to the end of the file, remove the line
         `set_target_properties(${RB_EXEC_NAME}   PROPERTIES PREFIX "../")`

2. Retrieve the RevBayes sources.

    1. Open a cygwin terminal window
    2. Clone the git repository:
        ```
        git clone https://github.com/revbayes/revbayes.git revbayes
        ```
        
    If you have already obtained the source code by another method, 
    navigate to the folder that contains it.  To get to the folder `c:/RevBayes`,
    use `cd /cygdrive/c/RevBayes`.

3. Compile RevBayes.

    1. Open a cygwin terminal window and go to the RevBayes source directory if you haven't already done so, e.g., 
        ```
        cd revbayes
        ```
    2. Next, go into the projects and then the cmake subdirectory: 
        ```
        cd projects/cmake
        ```
    3. Now you can either build the standard version
        ```
        bash build.sh -DCMAKE_TOOLCHAIN_FILE=../mingw64_toolchain.cmake
        ```
        or the RevStudio version
        ```
        bash build.sh -DCMAKE_TOOLCHAIN_FILE=../mingw64_toolchain.cmake -cmd true
        ```
        
    - If you see the error `build.sh: line ##: $'\r': command not found`,
    you need to convert to Unix line endings (`\n` rather than Windows `\r\n`).
    Open the problematic file – here, (`build.sh`) –
    in [Notepad++](https://notepad-plus-plus.org/),
    use the Edit menu→EOL conversion→Unix (LF),
    then save the file.
        
    - If you installed Boost manually, rather than using the Cygwin package, 
    you will need to update `src/CMakeLists.txt` to tell cmake where to 
    find Boost.
    
    - If you encounter problems finding specific Boost libraries (e.g. regex),
      a common issue is that the boost libraries have been built using a 
      different toolkit (e.g. a different version of gcc) to the toolkit being
      used to build RevBayes.
      It may help to switch from the Cygwin shell to a regular command prompt,
      or to use [VSCode](https://revbayes.github.io/developer/setup/#vscode)
      to build the project.
      Add the line `set(Boost_DEBUG ON)` to the top of your `CMakeLists.txt` file
      to see the toolset used to build Boost (which may differ, confusingly, from
      the filenames of the compiled libraries in `C:\boost\boost_1_82_0\gcc\lib`).
      This should match the version number reported by `gcc -v`.

4. Library whack-a-mole

    When you try to run the executable you will likely get an error about missing libraries. 

    Make a new directory and put the executable in it. 

    Then find the library from the error message in `/usr/x86_64-w64-mingw32/sys-root/mingw/bin/` and copy it to the directory you put the exectuable in. Repeat this until you stop getting error messages. 

    At the time this was written (RevBayes v1.1.0), this consisted of:

    * iconv.dll
    * libatk-1.0-0.dll
    * libboost_filesystem-mt.dll
    * libboost_program_options-mt.dll
    * libboost_system-mt.dll
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
