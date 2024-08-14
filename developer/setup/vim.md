---
title: Setting up vim for RevBayes development
order: 5
---

[Vim](http://www.vim.org) is a text editor that some people love.
It's not an IDE, but it can provide useful IDE-like behaviors.
If you are reading this, you are probably a vim-lover and already have a set of customizations that you like.
Here are some more to consider.

YouCompleteMe
----------------------

[YouCompleteMe](https://github.com/Valloric/YouCompleteMe) is an extremely useful plugin that provides suggestions as you type for function names, prompts about their arguments, etc.
There are several steps to get it working.

### Install dependencies

This seems to be sufficient on Ubuntu 16.04:
```
sudo apt-get install build-essential cmake python-dev python3-dev clang
```
{:.bash}

### Get the vim code itself

Grab these two plugins:

* [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
* [YCM-Generator](https://github.com/rdnetto/YCM-Generator)

Put them wherever you put your plugins, e.g., `.vim/bundle/` if you're using [Pathogen](https://github.com/tpope/vim-pathogen).

For YCM, you also need to get its submodules:
```
cd YouCompleteMe/
git submodule update --init --recursive
```
{:.bash}
(If you manage your plugins as git subtrees, note that you probably can't for YouCompleteMe because it contains submodules itself.)

### Compile the YCM plugin

YCM has a compiled component as well as vim code.  This may take a few minutes to run.
```
cd YouCompleteMe/
./install.py --clang-completer
```
{:.bash}

### Provide the compilation flags to YCM

The above was to install YCM in general.
To use it specifically with RevBayes (or any other project), you need to give it information about the codebase.
YCM-Generator is one way to do this.

```
cd revbayes/  # or wherever you keep revbayes
cd projects/cmake/build/
~/.vim/bundle/YCM-Generator/config_gen.py . # adjust the vim path if necessary
```
{:.bash}

That should take a few seconds to run.
Then move the result to the top-level directory:
```
mv .ycm_extra_conf.py ../../../
```
{:.bash}

### Try it out

That should be it.
If YCM is working, when you open a revbayes `.cpp` or `.h` file, vim will ask `Found revbayes/.ycm_extra_conf.py. Load?`

If you find that you don't want YCM operating on all your other filetypes, you can put something like this in your `.vimrc`.
```
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python': 1 }
```
{:.vim}

### Debugging with GDB

If you use vim, we recommend debugging in GDB. You'll need to compile RevBayes with the `-debug true` flag:
```
./build.sh -debug true
```
{:.bash}

The you can debug RevBayes with GDB:
```
gdb rb
```
{:.bash}

See [here](https://www.cs.cmu.edu/~gilpin/tutorial/) for more on using GDB.