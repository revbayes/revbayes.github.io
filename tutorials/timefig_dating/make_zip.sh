#!/usr/bin/env sh
rm timefig_dating_project.zip
find ./ -name '.DS_Store' -type f -delete
find ./ -name 'history.txt' -type f -delete
zip -r timefig_dating_project.zip data scripts


