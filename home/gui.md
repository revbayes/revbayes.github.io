---
layout: home
title: GUI
subtitle: Use RevBayes with a Graphical Interface
permalink: /gui
code_layout: bash
---

{% section Graphical User Interfaces %}

RevBayes GUI is a graphical user interface for RevBayes. RevBayes GUI is written in Swift with the use of Cocoa libraries and runs on the macOS platform.

The complexity of the RevBayes program and the Rev language can be a significant barrier to the scientists wanting to use the program. It is the goal of the RevBayes GUI project to overcome that barrier. RevBayes GUI serves to simplify the use of RevBayes while at the same time expose its full functionality.

RevBayes GUI is a document-based application, with a collection of phylogenetic analyses seen as a document. The user can create an analysis by dragging the necessary components from a tool palette and dropping them on the analysis canvas. Adopting a convention from the field of graphical models in computer science, we allow a biologist specify their analysis as a graph. We use a tool metaphor to expose the functionality of the program. Each node in the graph is a tool that carries out a single task, such as reading and visualizing data from a file, setting the phylogenetic model graphically, aligning DNA sequences, etc. Tool Model, often the core of an analysis, allows the user to specify their model assumptions. Like with the analysis, RevBayes GUI exposes a model as a graph. The user can build up models graphically, by bringing together different mathematical components of a model just as a child would build a house out of Lego bricks.

Development of RevBayes GUI is funded by an NSF grant. It is an open-source project on GitHub. The <a href="https://github.com/svetakrasikova/macgui">GitHub repository</a> can be freely cloned.

If you would like to contribute to the project or report issues please contact the <a href="https://github.com/svetakrasikova">lead developer</a> to request access.
