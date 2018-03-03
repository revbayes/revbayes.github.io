---
layout: default
title: Developer
---
# RevBayes Developer's Manual

----
## Table of Contents
*(See [website](http://revbayes.github.io/about.html) for installing RevBayes)*

1. Overview of RevBayes layout

 * Github general info

     * Master branch

     * Development branch

 * General RevBayes layout info

    * levels within RevBayes

    * Dag folder

 * Data types

2. IDE's: getting RevBayes locally configured

 * General info 

 * List of various IDE's available

 * Steps for how to properly configure RevBayes in an IDE

3. Implementing a Function

 * General info about function types in RevBayes

 * Creating appropriate files in the  correct directories

4. Implementing a Distribution

 * Creating appropriate files in the correct directories

5. Implementing a Move

 * General info about moves directory in RevBayes

 * Steps for implementing a new Move

6. Building and Analyzing a new Model

 * Critical components

 * Steps

7. Testing suites/validation scripts

8. Writing simulation scripts

----
## 1. Overview of RevBayes Layout

**The Branching Git-flow used is:**

*Master branch*: always stable; releases are tagged off of this

*Development branch:* Always branch off of this. Then merge with master, and then release from the Master branch. If you make a new branch, merge it with *Development* first & then merge with *Master*.

 * *Note:* If you don't want to make any big merged changes but want to play around with new things, use git fork.

**General RevBayes layout info:**

RevBayes is written in object-oriented C++. There is a heirarchy of classes, so developers will most often need to work with the 'abstract/parent' class. However, it's sometimes necessary to use sub-classes. You can follow the paths to the parent class through the code to find who owns a subclass.

There are two main directories within RevBayes:

 * revlanguage

 * core

**.h = header files** (where you define the class and reference the .cpp files).

**.cpp = C++ files** (where you implement the RevBayes functionality/distributions/etc. and reference the header file code).

Note: Anytime you write anything new, you must add it to an "RbRegister_" file, located in /revlanguage/workspace/ (there are separate RbRegister files for adding new functions, distributions, moves, types, help documentation, etc.)

*In the backend, if you write a new function/distribution you must create files for it in both the revlanguage and the core folders. Specifics on this are included in the 'Implementing a Function' and 'Implementing a Distribution'*



**Dag Folder:** contains different types of stochastic nodes & features necessary for graphical model components 



**Data Types:** These are the different object types in RevBayes. There are a lot, so it's crucial you use  the right ones.

 * Examples: natural, real, probability, vectors, etc.


----
## 2. IDE's

**General info:**

 * *Examples of IDE's*: XCode, Eclipse Oxygen, etc.

 * **add info about using a standard text editor instead**


 * **add info about vim...Will Freyman & Emma use this**

 * XCode does not keep track of files, so each time you open your RevBayes project in XCode you must pull revbayes-master from git & remove reference to all of the source. 

 * Eclipse Oxygen does a cleaner job of managing the files; you do not need to pull from git each time you work in it. 


**Creating a RevBayes project in XCode**

1. Click on “Create a new Xcode project”

2. Click on “Command Line Tool”

3. Name your project (e.g. revbayes_work)

4. This will open up the editor window. On the left hand‑side there will be a list of files. Delete all of these, except for Products
5. Now go to file ‑> add files to ‑> navigate to where you have revbayes installed. Within the revbayes directory, find src/ and then add these three folders: core, libs, and revlanguage. Assuming your revbayes directory is version controlled using git you can now edit files in Xcode and version control from your revbayes directory.

6. Now you need to change some settings. Click on the blue xcode icon on the top left hand side of your editor (it should be above some yellow folders).

7. Now go to the ‘Build Settings’ tab and ensure you’re on the ‘All’ selection (rather than Basic or Customized). Then, scroll down to the “Apple LLVM [9.0] - Preprocessing” section, and under “Preprocessor macros” set the Debug value to 1 as follows: RB_XCODE=1

8. Now scroll down to ‘Search Paths’ and under Debug and Release add: /Users/.../projects/revbayes/boost_1_60_0 to both 

9. Scroll to “Apple LLVM ‑ [9.0] Language‑ C++” and change the ‘C++ language dialect’ to GNU++98 and change the ‘C++ standard library’ to libstdc++

[**Creating a RevBayes project in Eclipse**](eclipse-config/README.md)

**Add in steps for setting up vim**

----
## 3. Implementing a Function

**General info**:
There are different types of functions in RevBayes: 

 * Virtual functions: within the parent class

 * Member functions: do something on an object

 * Typed functions": take in an object

 * Update functions: **Fill in**

 * Deterministic functions: create deterministic nodes. Must be created in the core folder.

*Note: if we want to return a deterministic node, then we need to write a member method (example: a tree statistic).* 

**Steps**

1. Depending on the type of function you are creating, you'll create it in one of the following categories:

 * For member functions: create a new file in /revlanguage/datatypes/

 * For other functions: create a new file in revlanguage/functions/... (use appropriate subdirectory based on the nature of your function)

*Note: If you write a void/IO function, you don't need to put it in the core folder unless it returns core objects.*

**Add more steps**

*Note: Methods -> functions: returns a model object with a DAG node attached (contains member functions).*
*Methods -> procedures: returns a workspace object (contains method procedures)*

**Add specific steps for editing the RbRegister file**

----
## 4. Implementing a Distribution

**General info before getting started:**

Within RevBayes, there are math distributions and phylogenetic distributions. 
All predefined mathematical distributions that have been implemented exist in core/distributions/math.

Note that when implementing a new distribution, you will need to create .cpp and .h files in both the revlanguage directory and the core directory. For the language side, one of the most important things is the create distribution function (it converts user-arguments into calculations). Also, the getParameterRules function is important (to get the degrees of freedom & other things). As a rule of thumb, you can look at the code of existing distributions for general help on syntax & organization.

Within your new distribution, you will need to include some functions. For example, each new distribution must have: the get class type, name, and help. Some of these you may not need to implement (if it's dictated by the parent class & is already present), but others you will need to implement within the distribution. 

Distributions have a prefexed DN (dag node), and all moves have a previxed MV (move). RevBayes takes the name within & creates the DN automatically, so be aware of this. 
 
In the following steps, we'll implement the Beta Binomial Distribution as an example, for syntax purposes.

**Steps**:

1. Create new .cpp & .h files in /revlanguage/distributions/math/  (named Dist_betabinomial.cpp, Dist_betaBinomial.h )

2.
    a.  Create new .cpp & .h files in /core/distributions/math/  (named BetaBinomialDistribution.cpp, BetaBinomialDistribution.h ).

     *Note: This is the object oriented wrapper code, that references the functions hard-coded in step 2b.*
    b. Create new .cpp and .h files in /core/math/Distributions/  (named DistributionBetaBinomial.cpp, DistributionBetaBinomial.h ). 

    These are the raw procedural functions in revbayes namespace (e.g. pdf, cdf, quantile); they are not derived functions. RbStatistics = namespace.

    *Note: This is the most time-consuming step in the entire process of implementing a new distribution.*

3. Create a new .cpp and .h file in /revlanguage/workspace/  (filename: RBregister_BetaBinomialDistribution ). 

    *Note: Your new distribution won’t run or compile without this step. This step is also required when implementing new functions in RevBayes; not just distributions.*

4. Navigate to revlanguage/workspace/RbRegister_Dist.cpp 

    Every implementation you add must be registered in RevBayes. All register files are located in the revlanguage/workspace directory, and there are different files for the different implementations (RbRegister_Func.cpp is for new functions; RbRegister_Move is for new types; etc.). 
    We are implementing a distribution, so we'll add some lines of code to the RbRegister_Dist.cpp file.

    You need to have an include statement at the top of the rb registered script, to effectively add your code to the RevBayes language. You also need to include it at the bottom of this file, and give it a type and a ‘new’ constructor. Generally, you can look within the file for an idea of proper syntax to use. 

    For the Beta Binomial distribution, we navigate to the section in the file with the header 'Distributions' and then look for the sub-header dealing with math distributions. 
Then, add the following line of code: 
#include "Dist_betaBinomial.h". 
    
    *This step registers the header file for the beta binomial distribution, effectively adding it to RevBayes.*

    Next, navigate to the section of the file that initializes the global workspace. This section defines the workspace class, which houses info on all distributions.

    Then, add the following line of code: 
    AddDistribution< Natural				   >( new Dist_betaBinomial());
    
    *This adds the distribution to the workspace. Without this step, the betaBinomial will not be added to the revlanguage.*
    *Note: Depending on the type of distribution, you may need to change 'Natural' to a different type (e.g. 'Probability', 'Real', 'RealPos', etc.*


## 5. Implementing a Move

**General info:** Within the moves directory, efficiency can be greatly improved. But, it is not straightforward, and it's a pain to debug. 

It's important to think about what types of moves are required to work on different types of objects.

 **Fill in**

----
## 6. Building & Analyzing a new model

**Critical components:**

 * Distributions, Functions, and Moves

  These are needed to work on components of any new model. 

*Note*: All predefined mathematical distributions exist in core/distributions/math 


----
## 7. Testing Suites/validation scripts

**General info**:

It's tricky to test things in RevBayes unless you have a lot of things to test. So, sometimes you may want to write Rev code to "test" your new implementations in a hack-y way. If it's working the way you want/expect, it will most likely compile successfully.



----
## 8. Writing simulation scripts


----
