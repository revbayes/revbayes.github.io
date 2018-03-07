---
title: Download and Install RevBayes
permalink: /software/
---

## Download Pre-compiled Executables

<table class="table table-hover ">
	<tr>
		<td valign="top" class="td4">
			<a href="https://github.com/revbayes/revbayes/releases/download/v1.0.7/RevBayes_Win_v1.0.7.zip" class="btn btn-primary" role="button">Windows</a>
		</td>
		<td valign="top" class="td5">
			<p class="p2"><span class="s1">Supported versions: 7+<span class="Apple-converted-space"> </span></span></p>
		</td>
	</tr>
	<tr>
		<td valign="top" class="td4">
			<a href="https://github.com/revbayes/revbayes/releases/download/v1.0.7/RevBayes_Mac_v1.0.7.zip" class="btn btn-primary" role="button">Mac OS X</a>
		</td>
		<td valign="top" class="td5">
			<p class="p2"><span class="s1">Supported versions: 10.6+<span class="Apple-converted-space"> </span></span></p>
		</td>
    </tr>
    <tr>
		<td valign="top" class="td4">
			<a href="http://github.com/revbayes/revbayes" class="btn btn-primary" role="button">Source</a>
		</td>
		<td valign="top" class="td5">
			<p class="p2"><span class="s1">Public git repository<span class="Apple-converted-space"> </span></span></p>
		</td>
    </tr>
</table>

<br>

## Compiling from Source on Linux

```
git clone https://github.com/revbayes/revbayes.git revbayes
cd revbayes/projects/cmake
./build.sh
```
{:.bash}
For the MPI version:
```
./build.sh -mpi true
```
{:.bash}

<br>

## Compiling from Source on Mac OS X

1. Make sure that you have a C++ compiler installed on your computer. GCC 4.2 (or higher) and Apple LLVM version 6.0 have both been used successfully. If you don't have a C++ compiler, you should install Xcode.

2. Make sure that you have CMake installed. One option to install CMake is using homebrew: 
    ```
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install cmake
    ```
    {:.bash}

3. Download RevBayes from our github repository. Clone the repository using git by running the following command in the terminal 
    ```
    git clone https://github.com/revbayes/revbayes.git revbayes
    ```
    {:.bash}

4. Open a terminal and go to the RevBayes cmake directory: 
    ```
    cd revbayes/projects/cmake
    ```
    {:.bash}

5. Now either build the standard version using the following:
    ```
    ./build.sh
    ```
    {:.bash}
   or build the MPI version to produce the rb-mpi executeable:
    ```
    ./build.sh -mpi true
    ```
    {:.bash}
    You will likely some compiler warning (e.g. `clang: warning: optimization flag '-finline-functions' is not supported`). This is normal. 

<br>

## Troubleshooting:

* `-bash: rb: command not found`
    
    The problem is that you tried to run RevBayes but your computer doesn't know where the executable is. The easiest way is to add the directory in which you compiled RevBayes to your system path:
    ```
    export PATH=<your_revbayes_directory>/projects/cmake:$PATH  
    ```
    {:.bash}

* `Error cmake not found!`
    Please double check that CMake is installed. For OS X, go to step 2 above.

* `Error can't find the libboost_filesystem.dylib library or Library not   loaded: libboost_filesystem.dylib` 
   
    You need to add the boost libraries to your path variable. You may find that you have to export this `DYLD_LIBRARY_PATH` every time you open a new terminal window. To get around this, you can add this to your `.bash_profile` or `.bashrc` file (which lives in your home directory). To change this, open a new terminal window and you should be in the home directory. If you do not have either of these files, use the text editor `nano` to create this file type:

    ```
    cd ~
    touch .bash_profile
    nano .bash_profile
    ```
    {:.bash}

    Then add the following lines, replacing `<your_revbayes_directory>` with wherever you put the Revbayes Github repository:

    ```
    export DYLD_LIBRARY_PATH=<your_revbayes_directory>/boost_1_60_0/stage/lib:$DYLD_LIBRARY_PATH
    export PATH=<your_revbayes_directory>/projects/cmake:$PATH  
    ```
    {:.bash}

    Then save the file using ctrl^o and hit return, then exit using ctrl^x. Now quit the Terminal app and reopen it and the boost libraries will forever be in your path.

