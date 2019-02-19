---
layout: home
title: Software
subtitle: Download and Install RevBayes
permalink: /software
code_layout: bash
---

<div class="row">

<div class="col-sm-4" align="center">
<h2>Mac OS X</h2>
<a href="https://github.com/revbayes/revbayes/releases/download/v1.0.10/RevBayes_OSX_v1.0.10.zip" class="btn btn-info" role="button">Download Executable (10.6+)</a>
</div>

<div class="col-sm-4" align="center">
<h2>Windows</h2>
<a href="https://github.com/revbayes/revbayes/releases/download/v1.0.10/RevBayes_Win_v1.0.10.zip" class="btn btn-info" role="button">Download Executable (7+)</a>
</div>

<div class="col-sm-4" align="center">
<h2>Source code</h2>
<a href="http://github.com/revbayes/revbayes" class="btn btn-info" role="button">GitHub Repository</a>
</div>

</div>

<br>

## Compiling from source
----
### Linux

    git clone https://github.com/revbayes/revbayes.git revbayes
    cd revbayes/projects/cmake
    ./build.sh

For the MPI version:

    ./build.sh -mpi true

<br>

### Mac OS X

1. Make sure that you have a C++ compiler installed on your computer. GCC 4.2 (or higher) and Apple LLVM version 6.0 have both been used successfully. If you don't have a C++ compiler, you should install Xcode.

2. Make sure that you have CMake installed. One option to install CMake is using homebrew:

    ``` 
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install cmake
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

    You will likely some compiler warning (e.g. `clang: warning: optimization flag '-finline-functions' is not supported`). This is normal. 

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

