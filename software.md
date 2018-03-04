---
layout: default
title: Software
permalink: /software/
---

# Download RevBayes

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

# Installation Instructions


### Installing RevBayes from source on Mac OS X


1. Make sure that you have a c++ compiler installed on your computer. GCC 4.2 (or higher) and Apple LLVM version 6.0 have both been used successfully. If you don't have a c++ compiler, you can get it on a Mac when you download and install XCode.

2. Make sure that you have CMake installed. One option to install CMake is using homebrew: 
    ```
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install cmake
    ```
    {:.bash}

3. Download RevBayes from our github repository. You can clone the repository using git by running the following command in the terminal 
    ```
    git clone https://github.com/revbayes/revbayes.git revbayes
    ```
    {:.bash}

4. Open a terminal and go to the RevBayes source directory if you haven't already done so, e.g., 
    ```
    cd revbayes
    ```
    {:.bash}

5. Next, go into the projects and then the cmake subdirectory: 
    ```
    cd projects/cmake
    ```
    {:.bash}

6. Now you can either build the standard version using the following:
    ```
    ./build.sh
    ```
    {:.bash}
   or, you can build the MPI version using the following to produce the rb-mpi executeable:
    ```
    ./build.sh -mpi true
    ```
    {:.bash}
    You will likely some compiler warning (e.g. `clang: warning: optimization flag '-finline-functions' is not supported`). This is normal. 

7. You should be ready to use RevBayes. We have listed below some potential issues to troubleshoot below.

### Troubleshooting:

* `Error cmake not found!`. Please go to step 2 in the Installation instructions.

* `Error can't find the libboost_filesystem.dylib library or Library not   loaded: libboost_filesystem.dylib`. 
   

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

* `-bash: rb: command not found`
    
The problem is that you tried to run RevBayes but your computer doesn't know where the executable is. The easiest way is to add the directory in which you compiled RevBayes to your path variable. You can do this by following exactly the instructions given above).

