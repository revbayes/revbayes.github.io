---
layout: tutorial
title: Introduction to Python Datatypes and Packages
subtitle: Blah blah blah
category: Data
prerequisites:
- intro
objectives:
- "Brief overview of basic datatypes like lists, tuples, & dictionaries."
- "Syntax for defining a function."
- "Installing, updating, and importing packages."
- "Verify that everyone's Python environment is ready."
keypoints:
- "Are you flying yet?"
---



# Python's Basic Built-in Datatypes

## Strings, integers and floats

The most basic data types in Python are strings, integers and floats:

~~~
text = "Go Cyclones"
number = 42
pi_value = 3.1415
~~~
{: .python}

Here we've assigned data to variables, namely `text`, `number` and `pi_value`,
using the assignment operator `=`. The variable called `text` is a string which
means it can contain letters and numbers. We could reassign the variable `text`
to an integer too - but be careful reassigning variables as this can get
confusing.

To print out the value stored in a variable we can simply type the name of the
variable into the interpreter:

~~~
text
~~~
{: .python}

~~~
Go Cyclones
~~~
{: .output}

however, in scripts we must use the `print` function:

~~~
# Comments start with #
# Next line will print out text
print(text)
~~~
{: .python}

~~~
Go Cyclones
~~~
{: .output}



## Sequential types: Lists and Tuples

### Lists

**Lists** are a common data structure to hold an ordered sequence of
elements. Each element can be accessed by an index.  Remember that Python indices start with 0 instead of 1:

~~~
numbers = [1,2,3]
numbers[0]
~~~
{: .python}

~~~
1
~~~
{: .output}

A `for` loop can be used to access the elements in a list or other Python data structure one at a time:

~~~
for num in numbers:
    print(num)
~~~
{: .python}

~~~
1
2
3
~~~
{: .output}

**Remember** _indentation_ is very important in Python. Note that the second line in the
example above is indented. This is Python's way of marking a block of code.

To add elements to the end of a list, we can use the `append` method:

~~~
numbers.append(4)
print(numbers)
~~~
{: .python}

~~~
[1,2,3,4]
~~~
{: .output}

Methods are a way to interact with an object (a list, for example). We can invoke
a method using the dot `.` followed by the method name and a list of arguments in parentheses.
To find out what methods are available for an object, we can use the built-in `help` command (you can exit the help page by typing `q`:

~~~
help(numbers)
~~~
{: .python}

~~~
Help on list object:

class list(object)
 |  list() -> new empty list
 |  list(iterable) -> new list initialized from iterable's items
 ...
~~~
{: .output}

We can also access a list of methods using `dir`. Some methods names are
surrounded by double underscores. Those methods are called "special", and
usually we access them in a different way. For example `__add__` method is
responsible for the `+` operator.

~~~
dir(numbers)
~~~
{: .python}

~~~
['__add__', '__class__', '__contains__', ...]
~~~
{: .output}

### Tuples

A tuple is similar to a list in that it's an ordered sequence of elements. However,
tuples can not be changed once created (they are "immutable"). Tuples are
created by placing comma-separated values inside parentheses `()`.

~~~
# tuples use parentheses
my_tuple = (0,1,2)
colours = ('red','blue','green')
# Note: lists use square brackets
my_list = [0,1,2]
~~~
{: .python}


> ## What happens when you try to change a list versus a tuple?
>
> Change the value of a single element in `my_list ` and `my_tuple `.
>
> > ## Solution: List
> >
> > ~~~
> > my_list[1] = 5
> > print("my_list =", my_list)
> > ~~~
> > {: .python}
> >
> > ~~~
> > my_list = [0, 5, 2]
> > ~~~
> > {: .output}
> {: .solution}
>
> > ## Solution: Tuple
> >
> > ~~~
> > my_tuple[1] = 5
> > ~~~
> > {: .python}
> >
> > ~~~
> >Traceback (most recent call last):
> >  File "<stdin>", line 1, in <module>
> >TypeError: 'tuple' object does not support item assignment
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

### Mixing Types

In Python, it is also possible to mix types in a list or tuple. This makes it easy to store data of variable type.
Thus, you can have a list that contains both natural numbers, floating point numbers, strings, lists, and tuples:

~~~
my_data = [('Manidae', 'Phataginus', 'tricuspis', 1821), 23.56, 30, [10.8,8.45,9.33]]
~~~
{: .python}

## Dictionaries

A **dictionary** is a container that holds pairs of objects - keys and values. This datatype is one of the most useful types in Python.

~~~
numbers = {"one" : 1, "two" : 2}
numbers["one"]
~~~
{: .python}

~~~
1
~~~
{: .output}

Dictionaries work a lot like lists - except that you index them with *keys*.
You can think about a key as a name for or a unique identifier for a set of values
in the dictionary. Keys can only have particular types - they have to be
"hashable". Strings, numeric types, and tuples are acceptable, but lists are not.

Here is a dictionary with natural numbers as keys. You access the values associated with each key, by providing the key in `[]`

~~~
numbers2 = {1 : "one", 2 : "two"}
numbers2[1]
~~~
{: .python}

~~~
'one'
~~~
{: .output}

You can also use a tuple as a key, but only if the tuple contains hashable elements (strings, numbers, tuples):

~~~
my_dict2 = {(1,2,3) : 3}
my_dict2
~~~
{: .python}

~~~
{(1, 2, 3): 3}
~~~
{: .output}

However, you cannot create a dictionary with a list as a key:

~~~
bad = {[1,2,3] : 3}
~~~
{: .python}

~~~
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
~~~
{: .output}


To add an item to the dictionary we assign a value to a new key:

~~~
numbers2 = {1 : 'one', 2 : 'two'}
numbers2[3] = 'three'
numbers2
~~~
{: .python}

~~~
{1: 'one', 2: 'two', 3: 'three'}
~~~
{: .output}

It is often necessary to check if the dictionary has a key before adding it, otherwise you will overwrite the value associated with that key:

~~~
if 4 not in numbers2:
    numbers2[4] = 'four'
numbers2
~~~
{: .python}

~~~
{1: 'one', 2: 'two', 3: 'three', 4: 'four'}
~~~
{: .output}


Using `for` loops with dictionaries is a little more complicated. We can do this
in two ways.

We can use the method `.items()` to return the key-value pair (this is the recommended way of iterating over a dictionary in Python):

~~~
for key, value in numbers2.items():
    print(key, "->", value)
~~~
{: .python}

~~~
1 -> one
2 -> two
3 -> three
4 -> four
~~~
{: .output}

Alternatively, you can iterate over the keys. When you loop over the dictionary in this way, Python just assigns the key value to the iterator variable:

~~~
for key in numbers2:
    print(key, "->", numbers2[key])
~~~
{: .python}

~~~
1 -> one
2 -> two
3 -> three
4 -> four
~~~
{: .output}


> ## Can you reassign the value of an element in a dictionary?
>
> Try to reassign the second value of `numbers2` (in the *key value pair*) so that it no longer reads "two" but instead reads "spam and eggs". What does your dictionary look like after you make this change?
>
> > ## Solution
> >
> > ~~~
> > numbers2[2] = 'spam and eggs'
> > numbers2
> > ~~~
> > {: .python}
> >
> > ~~~
> >{1: 'one', 2: 'spam and eggs', 3: 'three', 4: 'four'}
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

It is important to note that dictionaries are _unordered_ and do not remember the
sequence of their items (i.e., the order in which key:value pairs were added to
the dictionary). Because of this, the order in which items are returned from loops
over dictionaries might appear random and can even change with time.
If the dictionary's keys are of a single type that can be sorted (numbers or strings), then you can get a sorted list of the keys and iterate over it in a loop.

A loop over the unordered dictionary:

~~~
d = {3 : 'three', 2 : 'two', 6 : 'six', 5 : 'five'}
for key, value in d.items():
    print(key, ' = ', value)
~~~
{: .python}

~~~
3  =  three
2  =  two
6  =  six
5  =  five
~~~
{: .output}

To get a list of sorted keys, you can use the `sorted()` function on the list returned by the `.keys()` method:

~~~
d = {3 : 'three', 2 : 'two', 6 : 'six', 5 : 'five'}
for key in sorted(d.keys()):
    print(key, ' = ', d[key])
~~~
{: .python}

~~~
2  =  two
3  =  three
5  =  five
6  =  six
~~~
{: .output}


## Functions

Defining part of a program in Python as a function is done using the `def`
keyword. For example a function that takes two arguments and returns their sum
can be defined as:

~~~
def add_function(a, b):
    result = a + b
    return result

z = add_function(20, 22)
print(z)
~~~
{: .python}

~~~
42
~~~
{: .output}

# Python Packages

There are an immense number of Python packages (also called libraries) out there that do a lot of different things. Python doesn't have a heavily managed central resource like CRAN for R, but you can find a long and probably incomplete [list of packages for Python online](https://pypi.python.org/pypi/). Additionally, Anaconda provides easy installs of over 620 packages listed [here](https://docs.continuum.io/anaconda/pkg-docs).

## Installing New Packages

Anaconda helps install many important Python packages. You can use `conda` to install others that do not come with the default install. One very useful Python library for bioinformatics is [biopython](http://biopython.org/). You can install this it easily with `conda` from your terminal window.

```
$ conda install biopython
```

The prompt will ask you if you want to proceed with installing this package. Simply type `y` followed by the enter key and `conda` will manage the download and installation.

For packages that are not available via Anaconda, you may also be able to use the application `pip` to install. If you like using ggplot2 in R, you may like to use it in Python. The Python [ggplot](http://ggplot.yhathq.com/) package can be installed using `pip install`:

```
$ pip install ggplot
```

## Updating Packages

Anaconda makes it easy to update packages in `conda`. For any individual package, you can use `update`. The example below updates the package [pandas](http://pandas.pydata.org/), which allows us to deal with complex data structures.

```
$ conda update pandas
```

Alternatively, you can update all of the packages managed by Anaconda using:

```
$ conda update --all
```

For packages installed using `pip`, you can use the `-U` flag or `--upgrade`.

```
$ pip install ggplot -U
```

## Importing Packages

Once you have a package installed, you don't have to do that again (except you may have to update them from time-to-time). However, you cannot use a package in any Python instance without importing it first. This is quite simple.

Open a Python interpreter and type:

~~~
import ggplot
~~~
{: .python}

For convenience, you can also give packages aliases in your scripts. That way you don't have to type out the whole name each time. The example below imports the Python package [numpy](http://www.numpy.org/) and uses the `numpy.sum()` function to add up the values in a list. Notice that `np` is an alias for `numpy`.

~~~
import numpy as np
np.sum([2,4,6])
~~~
{: .python}

~~~
12
~~~
{: .output}

### Just for Fun

~~~
import antigravity
~~~
{: .python}

And sage advice:

~~~
import this
~~~
{: .python}



<!-- ## Check your Python Environment

Now that we have installed ggplot, let's check that our Python environment is ready for the lessons we'll do in class.
These lessons were mainly adapted from [Data Carpentry](http://datacarpentry.org/) lessons on Python.
That course provides an easy script that you can use to check your environment.

1. Download this file and save it to your `python-bcb546` directory: [check_env.py](https://raw.githubusercontent.com/datacarpentry/python-ecology-lesson/gh-pages/_includes/scripts/check_env.py).
2. Now run the file by executing it in your terminal window (make sure you're in the `python-bcb546` directory:

```
$ python check_env.py
```

If everything is installed properly you should get:

~~~
All checks passed. Your Anaconda installation is up and running and ready for Data Carpentry!
~~~
{: .output}

Otherwise you will get an error. If you do not get the message above, let's take some time to make sure everyone is on the same page. -->
