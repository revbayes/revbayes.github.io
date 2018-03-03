---
layout: tutorial
title: Git Workflow Best Practices
category: Developer
---

# Git workflow

The core branches of the `RevBayes` repo that should always exist are

-   `master`
-   `development`

The `master` branch should always reflect the state of the current release of
`RevBayes`.
The `development` branch should contain the working additions/changes to the
code to be included in the next release.
Under normal circumstances, neither of these branches should be worked on
directly.
Rather, a separate branch should be created to work on a new feature.

A great reference

-   <http://nvie.com/posts/a-successful-git-branching-model/>

