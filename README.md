revbayes-tutorials
==========================

This is the repository for the RevBayes tutorials website.

Because this site makes use of third party jekyll plugins, the static site is stored on branch `master`, while the source files are stored on branch `source`.

After first cloning this repository you should checkout the source branch. Then you should clone the master branch again to the `_site` directory.

	git checkout source
	git clone http://github.com/willpett/revbayes_tutorials.git _site

Then, when making changes to the tutorials, the static site should be rebuilt and committed as well. The script `jekgit.sh` takes care of the steps involved. After committing changes to the source, simply run the `jekgit.sh` script from the source repository, along with a commit message

	sh jekgit.sh <commit message>

In order to build the site you will need to [install `jekyll`](https://jekyllrb.com/docs/installation/) and the [`jekyll-scholar`](https://github.com/inukshuk/jekyll-scholar)
