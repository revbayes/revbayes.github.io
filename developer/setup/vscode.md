---
title: Setting up Visual Studio Code for RevBayes development
order: 0
---

Visual Studio Code (or VSCode) is an open-source text editor by Microsoft. You can download and install it <a href="https://code.visualstudio.com/Download">here</a>. 

Prerequisites
----------------------
You will first need to install RevBayes from <a href="https://revbayes.github.io/download">source</a>. Once RevBayes is installed you will need to open VSCode. Once VSCode is open you will need to select the RevBayes folder from wherever you have stored on your computer. 

Now you will need to install two extensions to get RevBayes to work nicely. To do this click on the button shown below in VSCode. 

<img src="images/Extension-button.jpg">

Getting RevBayes working 
------------------------

Once here you need to search for the <a href="https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools"> C/C++ extension </a>, the <a href="https://marketplace.visualstudio.com/items?itemName=twxs.cmake"> Cmake extension </a>, and the <a href="https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools"> CMake tools extension </a>.
Now that these are installed, Cmake tools will prompt in the lower right asking you to locate the file named `CMakeLists.txt`. Choose the file located in the `revbayes/src/CMakeLists.txt` location. This should begin building RevBayes using CMake and a new folder should appear in `revbayes` called `build`. This will contain the compiled files and will eventually be added to `.gitignore` if it is not currently you will need to add this to the `.gitignore` file. 

Once the Cmake build finishes, you can setup debugging by clicking the triangle with the small beatle in the lower left. Now click on the gear shown below. This will open a new file called `launch.json`. You need to change the values for the `"program:"` object to the path where your `rb` executeable is. For example, `"${workspaceFolder}/projects/cmake/rb"`. In vscode `${workspaceFolder}` refers to the root folder of the project you opened. To test a specific rev script, change the value of the `"args"` object to a location of a Rev script.With that you can use debugging in VSCode by pressing the play button or using the command palette (CTRL/CMD + SHIFT + P) and using the "Cmake: Debug" command.

<img src="images/screensho2.jpg">
