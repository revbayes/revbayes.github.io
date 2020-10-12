#!/bin/bash

scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"

# make sure we are in the repo root
cwd=`pwd`

if [ $cwd != $scriptpath ]
then
    echo "Error: deploy.sh must be run from the repository root."
    exit 1
fi

# make sure we are on source branch
branch=`git rev-parse --abbrev-ref HEAD`

if [ "$branch" != "source" ]
then
    echo "Error: Cannot deploy from branch '$branch'. Switch to 'source' before deploying."
    exit 1
fi

# make sure there are no changes to commit
if git diff-index --quiet HEAD --
then
    msg=`git log -1 --pretty=%B`

    git pull origin source

    # fetch master
    cd _site
    git fetch --quiet origin
    git reset --quiet --hard origin/master

    # update the documentation?
    if [ "$1" != "help" ]
    then
    git update-index --no-assume-unchanged documentation/index.html
    git ls-files --deleted -z documentation | git update-index --no-assume-unchanged -z --stdin
    else
    git update-index --assume-unchanged documentation/index.html
    git ls-files --deleted -z documentation | git update-index --assume-unchanged -z --stdin
    fi

    # build the site
    cd ..
    if ! bundle exec jekyll build; then
        echo "Jekyll build failed. Master not updated."
        exit 1
    fi
    cd _site

    # check if there are any changes on master
    untracked=`git ls-files --other --exclude-standard --directory`

    if git diff --exit-code > /dev/null && [ "$untracked" = "" ]
    then
        echo "Nothing to update on master."
        cd ..
    else
        # deploy the static site
        git add . && \
        git commit -am "$msg" && \
        git push --quiet origin master
        echo "Successfully built and pushed to master."
        cd ..
    fi
    
    # deploy source
    git push --quiet origin source
    echo "Deployment complete."
else
    echo "Error: Uncommitted source changes. Please commit or stash before updating master."
    exit 1
fi
