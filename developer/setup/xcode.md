---
title: Setting up XCode for RevBayes development
order: 0
---

 XCode is an IDE for Mac OSX. XCode does not keep track of files, so each time you open your RevBayes project in Xcode you must pull the RevBayes master branch from git & remove reference to all of the source. Eclipse Oxygen does a cleaner job of managing the files; you do not need to pull from git each time you work in it. 



Set up the XCode Project
------------------------

### Prerequisites

* To compile RevBayes using Xcode, first install [https://cmake.org/](CMake) and its [https://stackoverflow.com/questions/30668601/installing-cmake-command-line-tools-on-a-mac](command line tools). This is easily done using [https://brew.sh/](homebrew) by running `brew install cmake` in terminal.

### Create an Xcode project for RevBayes

1. Open Xcode and in the *Welcome to Xcode* window, choose **Create a new Xcode project**.
2. Click on the Cross-Platform tab at the top
3. Select **External Build System** and name it rb (or whatever you'd like)
4. Under **Build Tool** type the following directory `/<path-to-revbayes>/revbayes/projects/cmake/build.sh`
5. Click **Next**.

### Configure the build

1. After clicking **Next** as directed above, you should see a screen that looks like this: [figures/xcode-info.png]()
2. On this screen, under **Arguments** type `$(ACTION) -boost true -debug true`, or if you haven't built the boost libraries in RevBayes already. If you have then type `$(ACTION) -boost false -debug true`.
3. Under **Directory** put `/<path-to-revbayes>/revbayes/projects/cmake/`.
4. Add the source files by selecting the appropriate directory and going to the **File** pull-down menu and selecting **Add Files to <xcode-rb-project-name>**.
5. This should open a screen that looks like this: [figures/xcode-adding.png]()
6. Click on **Options** at the button of the window, and under the ***Added Folders*** heading, select **Create as Folder References**, and add to the target that was created in Step 2.
    * Select the following directories from the `revbayes` directory:
        * `revbayes/src/revlanguage`
        * `revbayes/src/core`
        * `revbayes/src/libs`
    * Click **Add**.
7. At this point, if everything has been setup correctly, you should be able to build the project. You can try by clicking on **Product - Build** or by using **&#8984;+B**.
8. Once revbayes has built go to **Product->Scheme->Edit Scheme**, it should bring a window like this: [figures/xcode-exe.png]()
9. Click on info, then go to executable and locate the newly built revbayes executable.
10. Now you should be able to click the play button or **&#8984;+R**, and you should see the revbayes command line prompt in the loading screen.