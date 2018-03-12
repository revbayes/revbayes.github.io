#!/bin/bash

branch=`git rev-parse --abbrev-ref HEAD`

if [ "$branch" != "source" ]
then
    echo "Error: Cannot deploy from branch '$branch'. Switch to 'source' before deploying."
fi

if git diff-index --quiet HEAD --
then
    msg=`git log -1 --pretty=%B`

    git pull origin source

    cd _site
    git fetch --quiet origin && git reset --quiet --hard origin/master
    cd ..
    if ! bundle exec jekyll build; then
    	echo "Jekyll build failed. Master not updated."
    	exit 1
    fi
    cd _site

    untracked=`git ls-files --other --exclude-standard --directory`

    if git diff --exit-code > /dev/null && [ "$untracked" = "" ]
    then
        echo "Nothing to update on master."
        cd ..
    else
        git add . && \
        git commit -am "$msg" && \
        git push --quiet origin master
        echo "Successfully built and pushed to master."
        cd ..

        git add _site
        git commit --quiet --amend -m "$msg"
    fi
    
    git push --quiet origin source
    echo "Deployment complete."
else
    echo "Error: Uncommitted source changes. Please commit or stash before updating master."
    exit 1
fi
