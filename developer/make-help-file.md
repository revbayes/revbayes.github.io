---
title: Adding a RevBayes help file
subtitle: How to write and upload a help file.
category: Developer
order: 1
---

{% include overview.html %}
{:style='width: 100%;'}

{% section Set up GitHub Access %}

- Ask someone to send you an invite to the revbayes organization: 
   - Ben Redelings, Tracy Heath, Michael Landis, Sebastian Hoehna, and Joelle Barido-Sotani can do this [here](https://github.com/revbayes/revbayes/settings/access).
- [Generate an ssh public/private key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) if you don't have one.
- [Add the public key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to your github account.
- Clone the revbayes repo:
  ```
  git clone git@github.com:revbayes/revbayes.git
  ```
- Alternatively, if you already cloned the repo, then you may need to change the origin URL for your repo from one that starts with `https:` to one that starts with `git@`.
  ```
  git remote -v              # check if the URL for origin starts with https: or git@
  git remote rm origin
  git remote add origin git@github.com:revbayes/revbayes.git
  git remote -v              # check that the origin URL now starts with git@
  ```
{% section The `development` branch is "protected" %}

RevBayes does not allow pushing to the `development` branch directly.
Instead, you should create a new branch off of `development` and add your changes there.
In order to merge these changes into the `development` branch you will first create a "pull request" (PR) based on your new branch.
The pull request is a request to merge the changes into the `development` branch.
If automatic tests pass for the the new branch, and the pull request is approved by someone, then you can merge the changes into `development`.


{% section Push a branch %}

First, make sure you are currently on the `development` branch so that your new branch starts from the right place.

    git checkout development
    git branch
    git log

Then make a new branch:

    git branch my-new-branch-name
    git checkout my-new-branch-name
    git branch

Finally, let's commit some changes.  Let's suppose that you are modifying the help file `help/md/something.md`.  So edit this file and save it.  Before you do this, you might want to [change the default editor](https://unix.stackexchange.com/questions/501862/how-can-i-set-the-default-editor-as-nano-on-my-mac).

    git status                          # check that the file you changed is shown as modified
    git add help/md/something.md
    git status                          # check that your modified file is staged
    git commit
    git push --set-upstream=origin my-new-branch-name

The changes that you committed will then be publicly available from github.
They do not need to be perfect: making them public allows others to comment on your work, review it, and make suggestions.

{% section Make a Pull Request (PR) %}

- Go to <https://github.com/revbayes/revbayes/pulls>.
- If you just pushed a branch, then there should be a green button to make a PR for that branch.  Otherwise, click the green button `New pull request`.
- Change the left branch button (the base) from `master` to `development`.
- The right branch button should be the branch with the changes that you want to merge.

{% section Update a help file %}

- Choose a help file in `help/md/` to modify.
- Look at `help/md/dnNorm.md` for an example of what the fields mean, and what information should be included.
- Q: How much information?  A: Try to include the essential information without letting the file get too long.
- The `description` should be about 1 line.  Longer information goes in the `details`.
- General background information (e.g. "what is a prior"?) that can be found on wikipedia should not go in the help files.
- You need to run `projects/generate_help.sh` to copy information from the markdown files in `help/md` into the C++ code.





