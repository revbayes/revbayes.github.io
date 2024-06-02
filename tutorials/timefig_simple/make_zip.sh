#!/usr/bin/env sh
rm timefig_simple_project.zip
find ./ -name '.DS_Store' -type f -delete
find ./ -name 'history.txt' -type f -delete
cp -R _data data
zip -r timefig_simple_project.zip data scripts
rm -rf data

