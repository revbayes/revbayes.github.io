---
title: Setting up CLion for RevBayes development
order: 0
---

CLion is a cross-platform IDE for C and C++ by [JetBrains](https://www.jetbrains.com/clion/). 

Prerequisites
----------------------
To work in CLion you need to install CMake. On Mac OSX you can install via [homebrew](https://brew.sh/), `apt` on ubuntu, or [chocolatey](https://chocolatey.org) on windows, 

Follow the install instructions for [installing RevBayes](https://revbayes.github.io/software) from source. The only change is instead of running `./build.sh` run `./build.sh -debug true`. This should take a second so feel free to go to grab yourself a snack.

Create an CLion project for RevBayes
-----------------------------
Open CLion. It should look like this:
<img src="figures/clion-opening.png" width="50%">
Click on  "New CMake Project from Sources. This will open up a file tree, you need to find a file called `cmake_install.cmake`. You can see this below, mine was at `<where-revbayes-is>/revbayes/projects/cmake/build/`.

<img src="figures/clion-cmake.png" width="50%">

This will open the project in CLion and it should say in the bottom updating symbols... This part takes a bit, an additional snack may be warranted. After a bit you should also see in the upper right near the little hammer a dropdown menu that says `rb | DEBUG`.

<img src="figures/clion-ready.png" width="50%">

You should now be able to set a breakpoint and run your Rev script. The interactive Rev console does not work in CLion right now.
