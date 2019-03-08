---
title: Setting up XCode for RevBayes development
order: 0
---

 XCode is an IDE for Mac OSX. XCode does not keep track of files, so each time you open your RevBayes project in Xcode you must pull the RevBayes master branch from git & remove reference to all of the source. Eclipse Oxygen does a cleaner job of managing the files; you do not need to pull from git each time you work in it. 



Set up the XCode Project
------------------------
1. Make sure CMake is installed. This can be done using Homebrew with the following command: `brew install cmake`.
1. Open Xcode and in the *Welcome to Xcode* window, choose **Create a new Xcode project**.
2. Click on the Cross-Platform tab at the top
3. Select **External Build System** and name it rb (or whatever you'd like)
4. Under **Build Tool** type the following directory `/<path-to-revbayes>/revbayes/projects/cmake/build.sh` 
5. Under **Arguments** type `$(ACTION) -boost true` if you haven't built the boost libraries in RevBayes already. If you have then type `$(ACTION) -boost false`.
6. Under **Directory** put `/<path-to-revbayes>/revbayes/projects/cmake/` and click **Next**. 
5. Add the source files by selecting the appropriate directory and going to the **File** pull-down menu and selecting **Add Files to rb**.
6. Click on **Options** at the button of the window, and under the ***Added Folders*** heading, select **Create as Folder References**, and add to the target that was created in Step 2.
    * Select the following directories from the `revbayes` directory:
        * `revbayes/src/revlanguage`
        * `revbayes/src/core`
        * `revbayes/src/libs`
    * Click **Add**.
7. Under the project go to Build Settings and add `RB_XCODE` under `GCC_PREPROCESSOR_DEFINITIONS`.

At this point, if everything has been setup correctly, you should be able to build the project. You can try by clicking on **Product - Build** or by using **&#8984;+B**.