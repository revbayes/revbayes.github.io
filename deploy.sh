#!/bin/bash

# Exit if a command fails
set -e

scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"

# make sure we are in the repo root
cwd=`pwd`

if [ $cwd != $scriptpath ]
then
    echo "Error: deploy.sh must be run from the repository root."
    exit 1
fi

trap "echo; echo 'FAILED!'" EXIT
trap "echo; echo 'FAILED! (Interrupted)'" SIGINT

# make sure we are on source branch
branch=`git rev-parse --abbrev-ref HEAD`

if [ "$branch" != "source" ]
then
    echo "Error: Cannot deploy from branch '$branch'. Switch to 'source' before deploying."
    exit 1
fi

remote=`git remote get-url origin`

case $remote in
    git@*) ;;
    *) echo "Error: The repo URL must start with git@ to be writeable"
       echo
       echo "But your repo URL is"
       echo "    $remote"
       echo
       echo "To fix, run"
       echo "    git remote rm origin"
       echo "    git remote add origin git@github.com:revbayes/revbayes.github.io.git"
       echo
       exit 1
       ;;
esac

# if the _site directory is missing, create it.
# (we assume later that it exists).
if [ ! -d "_site" ] ; then
    echo "No _site directory, cloning the master branch into it."
    git clone git@github.com:revbayes/revbayes.github.io.git _site
    echo "Done."
fi

if [ ! -e "_site/.git" ] ; then
    echo "Error: The _site/ directory should be a separate git repo, but it is not!  Please remove it."
    exit 1
fi

# make sure there are no changes to commit
if ! git diff-index --quiet HEAD --
then
    echo "Error: Uncommitted source changes. Please commit or stash before updating master."
    exit 1
fi

# make sure there aren't untracked files that will get uploaded to the website
UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
if [ -n "${UNTRACKED_FILES}" ] ; then
    echo "Error: Untracked files.  Please commit or stash before updating master."
    exit 1
fi

# make sure the source branch is up-to-date with origin/source
echo "Fetching content from remote"
git fetch --quiet origin

COUNT_MISSING="$(git rev-list --count source..origin/source)"
if [ "${COUNT_MISSING}" != 0 ] ; then
    echo "Error: the 'source' branch is not up-to-date.  Please do a 'git pull'"
    exit 1
fi

COUNT_EXTRA="$(git rev-list --count origin/source..source)"
if [ "${COUNT_EXTRA}" != 0 ] ; then
    echo "Error: the 'source' branch contains changes that have not been merged!"
    echo
    echo "    Please create a PR for these changes. After the PR is merged, "
    echo "    please pull from the source branch and run the ./deploy.sh script again."
    exit 1
fi

# Check out master in _site
echo "Checking out master in _site"
(
    cd _site
    git fetch --quiet origin
    git checkout --quiet master
    git reset --quiet --hard origin/master

    # update the documentation?
    if [ "$1" = "help" ]
    then
        git update-index --no-assume-unchanged documentation/index.html
        git ls-files --deleted -z documentation | git update-index --no-assume-unchanged -z --stdin
        git ls-files -z documentation | git update-index --no-assume-unchanged -z --stdin
    else
        git update-index --assume-unchanged documentation/index.html
        git ls-files -z documentation | git update-index --assume-unchanged -z --stdin
        git ls-files --deleted -z documentation | git update-index --assume-unchanged -z --stdin
    fi
)
echo

# build the site
echo "Running jekyll to build the static site."
if ! bundle exec jekyll build; then
    echo "Jekyll build failed. Master not updated."
    exit 1
fi
echo

# deploy master
(
    cd _site
    msg=`git log -1 --pretty=%B`

    # check if there are any changes on master
    untracked=`git ls-files --other --exclude-standard --directory`

    if git diff --exit-code > /dev/null && [ "$untracked" = "" ]
    then
        echo "Nothing to update on master."
        cd ..
    else
        # deploy the static site
        echo "Updating the master branch."
        git add . && \
            git commit -am "$msg" && \
            git push --quiet origin master
        echo "   Successfully built and pushed to master!"
    fi
)
echo

trap - EXIT

echo "Deployment complete."

