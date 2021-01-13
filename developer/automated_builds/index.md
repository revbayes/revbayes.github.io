---
title: Automated building and testing in RevBayes
subtitle: Quick automated feedback on code changes
category: Developer
---

{% section Automated builds %}

A series of automated builds and tests is run every time code is pushed to the repository in any branch through Github Actions. The status of current workflows can be checked on the repository [page](https://github.com/revbayes/revbayes/actions), and a notification is sent to Slack (channel #github) once the full workflow is complete.

The Github Actions workflow is configured in the `.github/workflows/build.yml` file. Linux and Mac builds use the CMake build configured in `projects/cmake/build.sh`, while the Windows build uses the Meson build.

The automated workflow runs the following tests:

 * Tutorial tests
 
 * Integration tests (in the `tests/` submodule). To learn more about integration tests or add one, see [this page](/developer/tests/). 
 
 * Likelihood calculations checks using [testiphy](https://gitlab.com/testiphy/testiphy).

{% section Troubleshooting %}

Known issues:

 * the Windows build fails at the `Configure and build` step with the message `ERROR: Dependency "boost" not found`. The `Install BOOST` step shows `ERROR 404` when attempting to download BOOST. 
 
 **Resolution:** BOOST and other necessary libraries for the Windows build are downloaded from a repository which periodically removes old versions. This error means that the versions used by RevBayes need to be updated in the file `projects/meson/make_winroot.sh`, l90. Available packages are listed [here](http://repo.msys2.org/mingw/x86_64/).
 
 
 * the Windows build fails at the `Test` step with an error message about a missing dll file. 
 
 **Resolution:** the missing DLL can be downloaded from the repository [here](http://repo.msys2.org/mingw/x86_64/). It needs to be added to the download list in file `projects/meson/make_winroot.sh` (l90) and moved to the build folder by adding the instruction `cp /home/runner/win_root/mingw64/bin/your_missing_file.dll ${GITHUB_WORKSPACE}/wincrossbuild/bin` to the file `.github/workflows/build.yml` in step `Configure and build (Windows meson cross compile)`. For an example already present in the build, see `libwinpthread-1.dll`. 
 
 
 * the Mac build fails at the `Install` step with Homebrew-related errors. 
 
 **Resolution:** this is not a RevBayes issue, but an issue with the Mac virtual environment set up by Github. A list of current issues (and possible workarounds) can be found [here](https://github.com/actions/virtual-environments/issues).