#!/bin/bash

if git diff --exit-code > /dev/null
then
    git pull
    git push

    msg=`git log -1 --pretty=%B`

    cd _site
    git fetch origin && git reset --hard origin/master
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
    else
        git add . && \
        git commit -am "$msg" && \
        git push origin master
        echo "Successfully built and pushed to master."
    fi
    cd ..
else
    echo "Error: Source changes not staged for commit.\nPlease commit or stash before updating master."
    exit 1
fi
