---
layout: default
root: .
---

# Welcome to the RevBayes tutorials repository

The materials we will work through are a sample of the lessons created for [Data Carpentry](http://www.datacarpentry.org/python-ecology-lesson/00-short-introduction-to-Python/) and [Software Carpentry](http://swcarpentry.github.io/python-novice-inflammation). 
The goal of this section is to demonstrate the utility of Python for working with biological data. 

## The Tutorials

Most of the lessons we will use for this course were written for the [Data Carpentry](http://www.datacarpentry.org/) series of workshops. In particular, we are using the [Data Analysis & Visualization in Python: Python for Ecologists](http://www.datacarpentry.org/python-ecology-lesson/) set of lessons. It is worth noting that one of the primary contributors and maintainers of this teaching material is [April Wright](https://paleantology.com/the-wright-lab/), a former postdoc in EEOB at Iowa State and now an assistant professor at Southeastern Louisiana University. 

The data we are using for this lesson are from the Portal Project Teaching Database -
[available on FigShare](https://figshare.com/articles/Portal_Project_Teaching_Database/1314459).
More details about the files we'll use and where to downlod them are available on the "[Setup](setup/)" page


> ## Prerequisites
>
> Learners need to understand the concepts of files and directories
> (including the working directory) and how to start a Python
> interpreter before tackling this lesson. This lesson references the Jupyter (IPython)
> Notebook although it can be taught through any Python interpreter.
> The commands in this lesson pertain to **Python 3**.
{: .prereq}

### Getting Started
To get started with installing Python, follow the directions given in the [Week 08](https://eeob-biodata.github.io/BCB546X-Fall2017/Week_08)
folder of the class repository.
You will also have to create a directory to work from and download some files. You can find instructions for doing that in the "[Setup](setup/)" page. 

### Tutorial Format

These tutorials will provide command line text and code in specific formats.

All commands that are intended to be executed in your Unix terminal will be shown in gray boxes with the `$` prompt. For example:

~~~
cd my_directory
pwd
~~~
{:.terminal}

All Rev code will be shown in light blue boxes with the `>` prompt:

~~~
int i = 0;
i = 12;
for(int j = 0; j < 100; j++) {
	#this is a comment
	i++;
}
~~~

All output the RevBayes console will be given in light blue boxes with gray text:

~~~
/home/my_directory
~~~
{:.output}