---
title: RevBayes Git Workflow
subtitle: How to contribute code effectively
category: Developer
order: 1
---

{% include overview.html %}
{:style='width: 100%;'}

{% section Contribution process %}

{% subsection Working on the RevBayes repository %}

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

The branch `hotfix-development` exists for small (*one* commit only) changes that are not worth creating a new branch for (for instance, small bugfixes, readme or help files edits, etc.). A pull request can then be created to merge those changes into `development`.

New features should *never* be merged directly into `master`. Only hotfixes to the current release may be merged into `master`.
For hotfixes, create a separate branch from `master`, make the fix and verify
it, and then merge the hotfix branch into `master` and `development`. Similarly to above, the `hotfix-master` branch exists for small (*one* commit only) bugfixes to the current release. A pull request can then be created to merge those changes into `master` and `development`.

For more information, please follow this illustrated [guide](Git_flow_illustrated.pdf).

{% subsubsection *Recommended reading* %}

The RevBayes workflow is inspired by this guide: <http://nvie.com/posts/a-successful-git-branching-model/>

{% subsection Forking the RevBayes repo %}

Forking the RevBayes repository is not mandatory as long as the workflow outlined above is respected. However, occasional developers or people who are considering contributing may fork their own copy of the repository on GitHub in order to keep the total number of branches reasonable. They can then contribute their changes via pull request.

{% subsection Automated tests %}

A suite of automated tests is run on all new pushes to the repository. The outcome of the tests will be notified by email to the author of the commits, and on Slack on the #github channel. More information on the tests and how to update them can be found [here](/developer/automated_builds/).

{% section Code review process %}

As mentioned above, all pull requests need to undergo a code review before being merged into the repository. All regular contributors to RevBayes may be asked to perform code reviews, so it is important to understand the process.

{% subsection Code review assignments %}

A developer creating a pull request may decide to request reviews from one or more people. These people will appear under the `Reviewers` heading. This is only a request, and is not binding. If you do decide to review a pull request you have been requested on, please assign yourself under the `Assignees` heading. This helps both the pull request creators and the people managing the repository to easily see which pull requests are actively under review and which are still looking for reviewers.

In case no reviewers were requested, or if all the requested reviewers are unable to do a review, a reviewer will be assigned from the list of available developers. If you are assigned, you will get a GitHub notification. If you are unable to review the pull request you have been assigned to, please contact the person who assigned you (whose name will appear in the notification as well as in the pull request's `Conversation` tab) so you can be replaced.

{% subsubsection *Reviewing guidelines* %}

Code reviews are an essential part of the current process, for two main reasons. First, the current suite of automated tests in incomplete, and may not catch all issues. Second, some issues such as missing documentation, or the introduction of a new model without an accompanying validation test, can only be caught by human eyes.

Some suggested checks for reviews are:

 * check that there is documentation and that it follows the RevBayes [guidelines](best_practices#doxygen_guidelines)
 * if existing functions have been changed or extended, check that the documentation, the help files and/or the RevBayes website (if applicable) have also been updated
 * check that the added code is readable: proper indentation, good names for functions and variables (no `bbb` or `thing` or `DoStuff`)
 * if a new model or probability distribution is introduced, check that corresponding validation  and integration tests have also been added
 * check that added code or functionality does not duplicate existing parts of RevBayes

Note that these are only suggestions and may not be applicable to all pull requests. Feel free to bring up any other issue you notice.

{% subsubsection *Checking out code* %}

Checking out the code in a pull request can be useful to run additional tests. If the pull request was created from a branch in the RevBayes repository, this can be done very simply by checking out the corresponding branch. Any changes committed and pushed to that branch will automatically be added to the pull request.

The process is more complicated if the pull request was created from a fork of the repository. In that case, you can check out the pull request by using the command `git fetch origin pull/ID/head:NAME`, where `ID` is the pull request number and `NAME` any name you like, followed by `git checkout NAME`. Note that this will only allow you to check out the code, and not to push any edits. To edit the pull request, you will need to clone the forked repository and push your edits to the branch that was linked in the pull request.

{% subsection Sending your review %}

Small issues (e.g. typos) can be fixed directly by the reviewer, either by editing directly the files on the GitHub website, or by following the process outlined above to check out a pull request.

Any other changes should be requested using the review option `Request changes`. The requests should state clearly what the issues are and where (file or function name) they appear.
The review option `Comment` can be used to ask questions. If there are no requests for changes or questions, select the review option `Accept`.

{% subsection Follow-up %}

The creator of the pull request is responsible for making the requested changes or otherwise addressing the comments. They can then re-request a review from the assigned reviewer, which will notify them to check the added changes and approve or make new comments.

Once the pull request is approved (directly or after changes) and the automated tests pass, the pull request can be merged into the repository. If some time has passed since the original request, it may be necessary to update the branch first (`Update branch` button). Updating and merging can be done by any developer.

Once the pull request has been merged, the branch it was created from should be deleted by its creator, unless they intend to keep working on that branch. 