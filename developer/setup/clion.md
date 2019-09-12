---
title: Setting up CLion for RevBayes development
order: 0
---

CLion is a cross-platform IDE for C and C++ by [JetBrains](https://www.jetbrains.com/clion/). To work in CLion you need
to install CMake.

First follow the install instructions for [installing RevBayes](https://revbayes.github.io/software) from source. First navigate to wherever the revbayes directory is, then go to the `projects/cmake` directory. Here you should see that there is a build directory, go to that directory. 

To set up CLion we need to use a compilation database which has the name `compile_commands.json`. To make this run `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` in this directory: `<your path to revbayes>/revbayes/projects/cmake/build`

After running this, within that directory you should have a `compile_commands.json` file.

Now open Clion, it should look something like this:

(screenshot)

Go to open and then navigate to the `compile_commands.json` file we just created. Click on open as project

This will open your project but right now on the left it should list all of the `.cpp` files alphabetically (not ideal).

To fix this, go to Tools -> Compilation Database -> Change Project Root and change that directory to the revbayes directory `<your path to revbayes>/revbayes/`


## Making a build configuration for RevBayes

Open Preferences/Tools -> Build, Execution, Deployment -> Custom Build Targets

Screenshot

Name your configuration and click on the ... by Build, then click the + in the window that pops up.

Screenshot

Next to program place the `build.sh` file found in `<your path to revbayes>/revbayes/projects/cmake`

In arguments type `-boost false -debug true`

Next to executeable find the RevBayes executeable which is in `<your path to revbayes>/revbayes/projects/cmake`. 

Click OK

Now the screen should looks like this and it should build if you go to Build and clikc Build Project

screenshot 

## Running and debugging configurations
We need to set up CLion to run the executeable for debugging to do this do the following:

1. Go to Run -> Edit Configurations
2. Click on the + and go to Custom Build Application
3. For target select the build configuration from above 
4. For executeable find the RevBayes program that was built
5. For working directory put the revbayes directory
6. Click Apply and then OK

Now you can run RevBayes by pressing Ctrl + R and set breakpoints and debug with Ctrl + D. 

Screenshot
