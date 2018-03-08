---
title: Git Workflow Best Practices
subtitle: How to contribute code effectively
category: Developer
order: 1
---

# Git workflow
{:.section}

Recommended reading:

-   <http://nvie.com/posts/a-successful-git-branching-model/>


## Getting started by forking the `RevBayes` repo
{:.subsection}

Due to the size of the `RevBayes` project and the number of developers
contributing to it, new developers should fork their own copy of the repository
on GitHub, and contribute their changes via pull request.

## Best practices when working in the code
{:.subsection}

The core branches of the `RevBayes` repo that should always exist are

-   `master`
-   `development`

The `master` branch should always reflect the state of the current release of
`RevBayes`.
The `development` branch should contain the working additions/changes to the
code that are to be included in the next release.
Under normal circumstances, you should not work on either of these branches
directly.
Rather, to make changes or work on a new feature, you should create a separate
branch off of `development`.
While working on your branch, frequently merge changes from `development` to
stay up to date.
Once your work is ready, and *before* you merge your branch into `development`,
make sure to merge any changes from `development` and verify the code is
compiling and tests are passing.
Never merge a feature branch directly into `master`, the only exception being
hotfixes to the current release.
For hotfixes, create a separate branch from `master`, make the fix and verify
it, and then merge the hotfix branch into `master` and `development`.
