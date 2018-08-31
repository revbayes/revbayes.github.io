---
title: Setting up Eclipse for RevBayes development
order: 1
---

Eclipse is a Java-based, cross-platform IDE with lots of nice features that make it convenient for RevBayes development. First, it's cross-platform, and unlike Xcode, you can use any compiler you like (not just `clang`).

Prerequisites
----------------------
- To compile RevBayes using Eclipse, you must install [CMake](https://cmake.org/install/) and its [command line tools](https://stackoverflow.com/questions/30668601/installing-cmake-command-line-tools-on-a-mac). This is very easy if you have [homebrew](https://brew.sh/) installed (`brew install cmake`)
- You must also have a C++ compiler. If you are using a Mac, you can use `clang` (included with [XCode](https://developer.apple.com/xcode/)), or you can install [`gcc`](https://gcc.gnu.org/) (e.g. via homebrew `brew install gcc`).

Installing Eclipse CDT
----------------------
To start writing C++ in Eclipse, you must obtain the Eclipse CDT (C/C++ Development Tooling) package. You can download a distribution of Eclipse that comes prepackaged with CDT from the [CDT Downloads page](https://cmake.org/download/).

If you already have Eclipse installed you can go to *Help > Install New Software...* and enter the p2 repository URL for your version of eclipse found on the CDT downloads page. Then check the *Main Features* box, click *Next* twice, accept the User Agreement, and restart Eclipse.

> **Important!** When you first open Eclipse, you will be asked to choose a location for your workspace. Make sure to choose a location that is not inside the source directory of your project!

Create an Eclipse project for RevBayes
-----------------------------
Assuming you have cloned the RevBayes github repository into the directory `<revbayes-repo>`, you can create a new C++ Eclipse project as follows:

1. In Eclipse, go to *File > New > Makefile Project with Existing Code*
2. Set the *Name* of the project to `revbayes`
3. Select `<revbayes-repo>/src` as the *Existing Code Location*
4. Select `Cross GCC` in *Toolchain for Indexer Settings* (you can change this later if you want).
5. Click Finish

Configure the RevBayes project
-----------------------------
You will need to configure your Eclipse project so it correctly compiles the revbayes CMake project.

### Configure the PATH environment variable
If you installed the CMake command line tools in the default location `:/usr/local/bin`, you must add it to the PATH environment variable of your Eclipse project.

1. In the *Project Explorer* view, highlight your revbayes project directory
<img src="figures/eclipse-explorer.png" width="50%">

2. Go to *Project > Properties*, or right click on the project name and select *Properties*.
3. Expand *C/C++ Build* and click on *Environment*
4. Click on the PATH entry, click *Edit...* and add `/usr/local/bin` to the end of the *Value*
![eclipse-path](figures/eclipse-path.png "PATH Configuration")

### Configure the C/C++ build settings
The RevBayes CMake project uses a special build script `build.sh` to build the RevBayes executable. You must tell your Eclipse project to use this script as a build command.

1. Click on *C/C++ Build*
2. Uncheck *Use default build command* and in *Build command*, enter `sh build.sh`
3. In *Build directory*, add `../projects/cmake` to the directory path
![eclipse-build](figures/eclipse-build.png "C/C++ Build Configuration")
4. Click on the *Behavior* tab
5. In *Build (incremental build)*, enter `-boost false`
![eclipse-behavior](figures/eclipse-behavior.png "C/C++ Build Behavior")
6. Again, click on *C/C++ Build*
7. Click *Manage Configurations*
8. Click on *New...* to create a new configuration, and name it *Debug*
<img src="figures/eclipse-config.png" width="75%">
9. Configure the Debug configuration by adding `-debug true` to the *Build (incremental build)* options
![eclipse-debug](figures/eclipse-debug.png "C/C++ Debug Configuration")
Now, if you set the active configuration to *Debug*, RevBayes will be compiled with debugger symbols that can be loaded by `lldb` or `gdb`. You can also set the active build configuration by going to *Project > Build Configurations > Set Active*

10. Click *Apply and Close*

At this point, C/C++ Indexer will get to work indexing the RevBayes code, during which time Eclipse might appear to be unresponsive.

### Configure the project to use spaces instead of tabs

RevBayes code is indented using spaces. However, by default Eclipse uses tabs. Configure your project to automatically insert 4 spaces when you press the Tab key.

1. Open *Eclipse > Preferences*
2. Expand *C/C++ > Code Style*
3. Click on *Formatter*
4. Click the *New...* button to create a new profile, name the profile (e.g. *"spaces"*) then click *OK* to continue
5. Click the *Indentation* tab
6. Under *General Settings* set *Tab Policy* to `Spaces only`
7. Click *OK* and *Apply and Close*

Build the RevBayes project
-----------------------------
The first time you build RevBayes, you will also need to build the included Boost libraries. You only need to do this once. To build the boost libraries, return to step 5 in the [build configuration section](#configure-the-cc-build-settings) and enter `-boost true` instead. Then after you've built the libraries, you can disable the Boost build flag by resetting `-boost false`.

With all the build settings correctly configured, you can build RevBayes by highlighting the project in the *Project Explorer* view, and then going to *Project > Build Project*. You can also right click on the project directory and select *Build Project*.

The *Console* view should display the progress of the compilation process.

You're done! Now you can find the `rb` executable in the `<revbayes-repo>/projects/cmake` directory.

Tips
-----------------------------
- Create a symlink of `rb` in your PATH, so it is automatically updated every time you build RevBayes. e.g.

	`sudo ln -s <revbayes-repo>/projects/cmake/rb /usr/local/bin/rb`
- If your *Project Explorer* or *Console* views disappear and you can't find them, go to *Window > Show View* to display various views.