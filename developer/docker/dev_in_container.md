## Developing in the Docker container

Ok now we are ready to get the container running. Use:

    docker run --entrypoint /bin/bash revbayesdockerfiles:ubuntu-latest

The container is now running. We just need to start it. To figure out the name of the container (since we didn't give it one), type `docker container ls`. It should have a name of two random words, mine is `peaceful-hertz`.

You want to start this with 
    docker start <container-name>

Now we can go to vscode type: `CTRL(CMD)+SHIFT+P`. This opens the command prompt. Type in `Remote` it will populate a drop-down list go to the one that says: `Remote-Container: Attach to running container`. This will open a new window and in the bottom left corner it should say 'Container: revbayesdockerfiles-latest'. 

The revbayes repository is in here. If we want to open it you can go to `Open folder` and navigate to that. It will be at `/revbayes`. 

If you want to debug you will need to install a debugger. For example, to install `gdb`, you can simply use the `apt` install manager (or `yum`/`dnf` on fedora/CentOS). You could also do this to install `valgrind` which does not work nicely on MacOS. Otherwise you can use them just as you would in terminal on your home machine. I am currently working on a full development environment that takes advantage of a more IDE-like environment for debugging so stay-tuned.