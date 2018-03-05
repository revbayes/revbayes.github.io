---
title: Implementing Moves
subtitle: Quick start guide to RevBayes development by adding a new move
category: implementation
---

# Implementing a Metropolis-Hastings Move
{:.section}

## General info before getting started
{:.subsection}

The steps to implementing a new move vary slightly, depending on the move's type (e.g., Metropolis-Hastings versus Gibbs). For the purposes of this guide, we will focus on a Metropolis-Hastings move.

## Steps:
{:.subsection}

1. _Orienting within the repository_ - As with implementing a new distribution or function, you'll need to add relevant code to both the core of RevBayes and on the language side. For the core, navigate in the repository to `src/core/moves`. For a Metropolis-Hastings move, we'll then go into the `proposal` directory. In this directory, you can find several templates for generic proposal classes, as well as folders containing moves for specific parameter types. To keep things easy, we'll focus on a single scalar parameter, so we'll navigate one step further into the `scalar` directory. 