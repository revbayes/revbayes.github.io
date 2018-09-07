---
title: Setting up XCode for RevBayes development
order: 0
---

 XCode is an IDE for Mac OSX. XCode does not keep track of files, so each time you open your RevBayes project in Xcode you must pull the RevBayes master branch from git & remove reference to all of the source. Eclipse Oxygen does a cleaner job of managing the files; you do not need to pull from git each time you work in it. 



Set up the XCode Project
------------------------
1. Open Xcode and in the *Welcome to Xcode* window, choose **Create a new Xcode project**.
2. Select **Command Line Tool** and name it `rb` and click **Next**. ![](figures/xcode-making_xcode_project.png)
3. Click **New Folder**  to create an empty directory and name it whatever you'd like.
4. Click **Create**.
5. Delete all of the files and folders in each of the directories including `main.cpp` so that RevBayes is empty. You can do this by selecting the folders and files, right clicking and selecting delete. When asked, choose **Move to Trash**. 
6. Add the source files by selecting the appropriate directory and going to the **File** pull-down menu and selecting **Add Files to rb**.
7. Click on **Options** at the button of the window, and under the ***Added Folders*** heading, select the **Create Groups** radio button.
    * Select the 
        * `revbayes/src/revlanguage`
        * `revbayes/src/core`
        * `revbayes/src/libs`
    * directories and click **Add**.
![](figures/xcode-adding_files.png)
    * _Note:_ On some versions of XCode, you may need to click on the "Options" Tab, and choose "Create Groups" for the import to work properly. This is the default behavior on most XCode installs.
8. Add the boost library to your Xcode project 
    * Select the RevBayes project and go to the **Build Settings**. 
    * Search for or Scroll down to the **Search Paths** heading and find the sub-heading named **Header Search Paths**.
        * Double click the heading, click the **+**, and add the value: `<path to revbayes repository>/revbayes/boost_1_60_0`. 
        * where `<path to revbayes repository>` = the location of the revbayes repository on your machine.
    * Now do the same for the **Library Search Paths**, but make sure that you add the path to the lib directory in boost `<path to revbayes repository>/revbayes/boost_1_60_0/stage/lib`
![](figures/xcode-finding_boost.png)
9. Add the boost linker flag
    * Scroll to the **Linking** section in the **Build Settings**
    * Go to **Other Linker Flags** and double click on the space. This will bring up a box where you can add the flag `-lboost_program_options`. 
![](figures/xcode-linking.png)

Add the `RB_XCODE` Preprocessor Macro to your Xcode project 
---------------------------------------------------------

1. Select the RevBayes project and go to the **Build Settings**. 
2. Search for or Scroll down to the **Apple LLVM X.X - Preprocessing** heading and find the sub-heading named **Preprocessor Macros**. 
3. Double click on right hand column, click on the **+** and enter `RB_XCODE`. Do not replace the debug flag that is already present.
![](figures/xcode-macro.png)
    
Check C++ language options
--------------------------

1. Select the RevBayes project and go to the **Build Settings**. 
2. Search or scroll to: **Apple LLVM X.X - C++ - Language **.
3. Make sure C++ Language Dialect is set to ***Compiler Default***.
4. Make sure C++ Standard Library is set to ***Compiler Default***
5. If you get compile errors with these settings, you might want to change these to:
    * Make sure C++ Language Dialect is set to ***Gnu++ 98***.
    * C++ Standard Library is set to ***libstdc++(Gnu C++)***
![](figures/xcode-cpp_lang_options2.png)

At this point, if everything has been setup correctly, you should be able to build the project. You can try by clicking on **Product - Build** or by using **&#8984;+B**.