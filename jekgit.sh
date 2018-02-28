#!/bin/bash
 
if [[ -z "$1" ]]; then
  echo "Please enter a git commit message"
  exit
fi
 
bundle exec jekyll build && \
  cd _site && \
  git add . && \
  git commit -am "$1" && \
  git push origin master && \
  cd .. && \
  echo "Successfully built and pushed to GitHub."