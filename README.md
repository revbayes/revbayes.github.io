revbayes.github.io
==========================

This is the repository for the RevBayes website.

Setting up this repo locally
=================

The static version of this site is stored on branch `master`, while the source files are stored on branch `source`.

First, you should clone the `source` branch

	git clone https://github.com/revbayes/revbayes.github.io

After first cloning this repository, you will be on the `source` branch. Then, you should clone the `master` branch into the `_site` directory.

	cd revbayes.github.io
    git clone -b master https://github.com/revbayes/revbayes.github.io _site

In order to build the site you will need `jekyll`, see instructions below to install.

Making changes to the site
=================

When making changes to the site, you should always work on the `source` branch. After committing your changes to `source`, simply run the `deploy.sh` script. This script will take care of the steps involved to push both the `source` and `master` branches to github. 

	./deploy.sh

Setting up jekyll
=================

In order to build the site you will need to install [`jekyll`](https://jekyllrb.com/docs/installation/).

To install `jekyll` and `bundler` (or update them):

    gem install jekyll bundler

If you get a permission error, you can install the `jekyll` and `bundler` gems
in your home folder using:

    export GEM_HOME=~/.gem
    gem install jekyll bundler


NOTE: You may get errors here that you need to update ruby to install these
gems. 

If you are having trouble on MacOS with system ruby being out of date, you can install ruby via homebrew with `brew install ruby`. Then you need to add the homebrew version of ruby to your path by adding:

    export PATH="/usr/local/Cellar/ruby/2.7.1_2/bin/:$PATH"

to your `.bash_profile` file. Then restart your terminal or `source .bash_profile`.


Next, move into the `revbayes.github.io` repo directory, and install required gems via:

    bundle install

Now, you should be able to build and serve the static HTML with:

    bundle exec jekyll serve

The previous command will cause a full rebuild of the site each time a file is modified. This can sometimes take a long time. You can selectively regenerate only modified files using the `--incremental` option

	bundle exec jekyll serve --incremental

This will reduce regeneration times substantially. However, keep in mind that if you add new files, or modify `_config.yml` or any plugins, you will need to do a non-incremental rebuild.

If you get the error "invalid byte sequence in US-ASCII", this seems to fix it:

    export LC_CTYPE="en_US.UTF-8"
    export LANG="en_US.UTF-8"
