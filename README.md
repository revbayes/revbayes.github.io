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


Setting up jekyll
=================

To install `jekyll` and `bundler` (or update them):

    gem install jekyll bundler

If you get a permission error, you can install the `jekyll` and `bunder` gems
in your home folder using:

    export GEM_HOME="${HOME}/.gem"
    gem install jekyll bundler

NOTE: You may get errors here that you need to update ruby to install these
gems. 

Next, move into the `revbayes_tutorials` repo, and install required gems via:

    bundle install

Now, you should be able to build and serve the static HTML with:

    bundle exec jekyll serve
