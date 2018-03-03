#!/bin/bash

if git diff --exit-code > /dev/null
then
	git pull

	msg=`git log -1 --pretty=%B`

	cd _site && git reset --hard && git pull -f
	cd ..
	bundle exec jekyll build && \
	cd _site

	if git diff --exit-code > /dev/null
	then
		echo "Nothing to update on master."
	else
		echo "$msg"
		echo "Successfully built and pushed to master."
		# git add . && \
		# git commit -am "$msg" && \
		# git push origin master
	fi
	cd ..
else
	echo "Error: Source changes not staged for commit.\nPlease commit to source before updating master."
fi
