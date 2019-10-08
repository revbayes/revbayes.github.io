---
title: RevBayes Git Workflow
subtitle: How to contribute code effectively
category: Developer
order: 1
---

## Branch organization
{:.subsection}

The main branches of the RevBayes repo exist are

-   `master`
-   `development`

The `master` branch should always reflect the state of the current release of
RevBayes. The `development` branch contains the working additions/changes to the
code that are to be included in the next release.

**You should not work on either of these branches directly.** Rather, to make changes or work on a new feature, you should create a separate branch off of `development`. While working on your branch, frequently merge changes from `development` to stay up to date.
Once your work is ready, and *before* you merge your branch into `development`,
make sure to merge any changes from `development` and verify the code is
compiling and tests are passing.
Once these checks have been done, create a pull request to merge your branch into `development`. You can request reviewers for your pull request directly via GitHub, or by asking on Slack. After your pull request is approved, or if it has not been reviewed within 30 days, it will be merged into `development`.

New features should *never* be merged directly into `master`. Only hotfixes to the current release may be merged into `master`.
For hotfixes, create a separate branch from `master`, make the fix and verify
it, and then merge the hotfix branch into `master` and `development`.

## Recommended reading

<http://nvie.com/posts/a-successful-git-branching-model/>

## Forking the RevBayes repo
{:.subsection}

Forking the RevBayes repository is not mandatory as long as the workflow outlined above is respected. However, occasional developers or people who are considering contributing may fork their own copy of the repository on GitHub in order to keep the total number of branches reasonable. They can then contribute their changes via pull request.
