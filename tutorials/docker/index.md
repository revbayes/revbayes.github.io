---
title: Using RevBayes with Docker
subtitle: Using a platform-independent container to run RevBayes on your computer or a computing cluster
authors:  Sarah Swiston
level: 0
order: 7
index: true
redirect: false

---

{% section Overview %}

Docker is a way to share pre-build, pre-configured, and platform-independent sets of programs and files. On the development side, a **Dockerfile** (a list of commands for building and configuring programs/files) is used to build an **image**, which can then be shared with others. On the user side, the image can be downloaded and run to create a **container**. Inside the container, you have access to all of the programs contained in the image, as well as any files you **mount** to the container when you run the image. It works a bit like a virtual machine, except it runs on top of the host operating system. A Docker image containing RevBayes, TensorPhylo, Python, R, Julia, and several other programs can be found on [Docker Hub](https://hub.docker.com/r/sswiston/rb_tp).

This tutorial explains how to install Docker on your computer, how to obtain a RevBayes Docker image, and how to use the image to run scripts on your computer or a computing cluster. This will require a basic familiarity with command line (navigating directories and entering basic commands), but does not require much programming.

{% section Setting up the tutorial %}

{% subsection Downloading a test script %}

This tutorial includes a test script called `test.Rev` so that you can assess whether the RevBayes Docker container is functioning properly after being installed. The test script can be found in the `Data files and scripts` box in the left sidebar of the tutorial page. Somewhere on your computer, you should create a directory (folder) for this tutorial, download the test script, and put the test script inside the directory. You can put this directory anywhere you want on your computer, but you will need to know the filepath to the directory in order to access it from the Docker container.

{% section Setting up Docker %}

{% subsection Joining Docker Hub %}

On [Docker Hub](https://hub.docker.com/), there are many Docker images available that contain a wide variety of programs. To use these images (including the RevBayes image), you will need to create an account. Docker Hub is free to join.

{% subsection Installing Docker Desktop %}

In order to use Docker on your computer, you will have to download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/). The desktop app allows your computer to run Docker images, and also provides a GUI for interacting with images and containers. Whenever you want to use a Docker image, you will need to start the Docker daemon first, and opening Docker Desktop is the simplest way to do this (although there are a few [other ways](https://docs.docker.com/config/daemon/start/) to start the Docker daemon). Docker has versions for Mac, Windows, and Linux. The RevBayes Docker image should work on any of these platforms.

{% subsection Downloading the image %}

A Docker image containing RevBayes, TensorPhylo, Python, R, Julia, and several other programs can be found at [hub.docker.com/r/sswiston/rb_tp](https://hub.docker.com/r/sswiston/rb_tp). The easiest way to obtain this image is with a `docker pull` command.

First, open Docker Desktop. This starts the Docker daemon so that you can run `docker` commands. If you do not open Docker Desktop first, you will receive an error when you try to run a `docker` command. Then, in the desktop app, sign into your Docker Hub account.

Next, open your command line and enter the following pull command:

```
docker pull sswiston/rb_tp:4
```

Docker will automatically store the image on your computer in a directory reserved for Docker images. You will not have to manually locate this image; Docker will be able to find it.

{% aside Image tags %}
If you go to the repository [hub.docker.com/r/sswiston/rb_tp](https://hub.docker.com/r/sswiston/rb_tp), you will see that there are several available images with different tags. These are built using different versions of programs, which are listed in the `README`. For this tutorial, we will use the image tagged `:4`.
{% endaside %}

{% section Using RevBayes via Docker%}

{% subsection Running RevBayes image via Docker Desktop %}

You can use the Docker Desktop GUI to run the RevBayes Docker image. Once you have run the image, you will be able to use RevBayes inside the Docker container, and run scripts. Here are the steps you will need to get RevBayes running:

1. Open Docker Desktop. If you are not already signed in to your Docker Hub account, sign in now (there will be an option in the upper right corner of screen).

2. There will be a tab on the lefthand side called `images`. In this tab, you will see all of the images you have downloaded.

3. Hovering over an image should give a `run` option. Click this option.

4. This should bring you to a screen with a dropdown menu called `optional settings`. You will want to click on this menu and change a few settings.

5. *Add a name to your container.* This is not strictly necessary, but it's very helpful if you plan to have multiple containers opened at a time. Otherwise, Docker will give the container a randomized name.

6. *Enter a host path.* This is how you tell Docker where to find your scripts on the host machine (your computer). To run the test script for this tutorial, you will have to tell Docker what directory to look in. You will need to use the absolute filepath to the directory. You can manually enter the filepath to this directory, or you can navigate to it using the `...` button. For example, if I put the test script in a directory called `docker_tutorial` on my desktop, I would put the filepath `/Users/Sarah/Desktop/docker_tutorial`. You can mount multiple directories from your host machine using the `+` button.

7. *Enter a container path.* This is how you will access your files while inside the Docker container. Mounting a directory in this way essentially creates a "connection" between the directory on the outside of the container (on your host machine) and inside the container. While inside the container, you will be able to see all of the contents of a mounted directory, including other sub-directories. For example, if you run RevBayes and want it to read a file from your host machine, you will use this filepath while inside the container. If you want to save files to your host machine from inside the Docker container, you will also use this filepath. There isn't a specific place inside the Docker container where you have to mount the directory, and it doesn't have to have the same name as the directory on your host machine. For example, you could call it `/tutorial`, which would put a directory called `tutorial` in the container's home directory with your test script in it.

8. Click the `run` option.

9. Another tab on the lefthand side of the screen should be called `containers`. Clicking this option should bring you to a screen showing all of the containers you currently have running.

10. To access the container as it is running, hovering over your container should give a `>_` option to open its command prompt. Clicking this option will open a command prompt window. Congrats, you are inside the Docker container! You should be able to access all of the programs and files in the container, and also the directory you mounted from your host machine.

11. Navigate to the location of your test script with `cd [filepath]`, using the filepath that you mounted your directory to in Step 7.

12. Now you can use RevBayes to run the test script with the command `rb test.Rev`. This should open RevBayes and run the script, which will give a message indicating that it has been run correctly:

```
   Processing file "test.Rev"
   Congrats! RevBayes is working!
```
{:.Rev-output}

{% subsection Running RevBayes image via command line %}

You can also run the RevBayes Docker image directly from command line. This will still require opening Docker Desktop to start the Docker daemon.

1. Open Docker Desktop. If you are not already signed in to your Docker Hub account, sign in now (there will be an option in the upper right corner of screen).

2. Open command prompt.

3. Run the command for opening the RevBayes Docker image:

    ```
    docker run --name [my_container] --volume [local_directory]:[container_directory] -i sswiston/rb_tp:4 /bin/bash
    ```

    Some parts of this command are directly analogous to the optional settings from the RevBayes GUI. 

    - `--name` adds a name to your container. This is not strictly necessary, but it's very helpful if you plan to have multiple containers opened at a time. Otherwise, Docker will give the container a randomized name.

    - `--volume [local_directory]:` is how you tell Docker where to find your scripts on the host machine (your computer). To run the test script for this tutorial, you will have to tell Docker what directory to look in. You will need to use the absolute filepath to the directory. For example, if I put the test script in a directory called `docker_tutorial` on my desktop, I would put the filepath `/Users/Sarah/Desktop/docker_tutorial`. You can mount multiple directories from your host machine by adding multiple `--volume` arguments.

    - `[container_directory]` is how you will access your files while inside the Docker container. Mounting a directory in this way essentially creates a "connection" between the directory on the outside of the container (on your host machine) and inside the container. While inside the container, you will be able to see all of the contents of a mounted directory, including other sub-directories. For example, if you run RevBayes and want it to read a file from your host machine, you will use this filepath while inside the container. If you want to save files to your host machine from inside the Docker container, you will also use this filepath. There isn't a specific place inside the Docker container where you have to mount the directory, and it doesn't have to have the same name as the directory on your host machine. For example, you could call it `/tutorial`, which would put a directory called `tutorial` in the container's home directory with your test script in it.

    - `-it` is for opening an interactive container. Docker containers can also be used to automatically run scripts and terminate when they are completed, but you will need an interactive container for this tutorial.

    - `sswiston/rb_tp:4` is the name of the Docker image you want to use.

    - `/bin/bash` opens up a Bash shell so that you can enter commands. This will allow you to launch RevBayes and run scripts.

    Congrats, you are inside the Docker container! You should be able to access all of the programs and files in the container, and also the directory you mounted from your host machine.

4. Navigate to the location of your test script with `cd [filepath]`, using the filepath that you mounted your directory to in Step 3.

5. Now you can use RevBayes to run the test script with the command `rb test.Rev`. This should open RevBayes and run the script, which will give a message indicating that it has been run correctly:

```
   Processing file "test.Rev"
   Congrats! RevBayes is working!
```
{:.Rev-output}

{% section Running on a cluster%}

Some high-performance computing clusters allow (or require) users to implement Docker images. For the most part, using a Docker image on a computing cluster is like using the image via command line on your own machine. You can mount directories, start a container, and use the programs inside to run scripts. However, there can be some additional considerations, depending on how the particular cluster is organized.

{% subsection Example: Wustl RIS%}

Washington University in Saint Louis Research Infrastructure Services (Wustl RIS) has a scientific compute platform that requires Docker to run jobs. Each job opens a separate Docker container. Interactive jobs allow users to access an interactive container where they can enter commands, start programs, and run scripts. Non-interactive jobs open a non-interactive container that automatically runs certain scripts, and then both the container and job terminate. In this example, we will show a non-interactive job.

Wustl RIS uses `bsub` commands to submit jobs. These commands can be written in one line, but they often have many arguments, so it can be helpful to put together a Bash script that constructs the `bsub` command. Here is an example:

```
LSF_DOCKER_VOLUMES="[Storage Directory]:/project"
PROJECTDIR="/project/"
NAME="MY_JOB"
OUTDIR="/project/joblogs/"

bsub \
-G [Compute Group] \
-q general \
-n 5 -M 20GB -R "rusage [mem=20GB] span[hosts=1]" \
-cwd $PROJECTDIR \
-J $NAME \
-o $OUTDIR$NAME.stdout.txt \
-a 'docker(sswiston/rb_tp:4)' /bin/bash /project/rev_shell.sh
```

Let's pick apart the elements of this script. There is a section at the top for defining variables, and then a `bsub` command using those variables.

- `LSF_DOCKER_VOLUMES` is how you mount a directory to the Docker container for the job. This variable will not be part of the `bsub` command itself, but when a new job is starting, it will look for this information. It has two parts.

    - `[Storage Directory]:` is how you tell Docker where to find your scripts in the cluster's storage.

    - `/project` is where the directory will be mounted inside the Docker container (in this example). There isn't a specific place inside the Docker container where you have to mount the directory, and it doesn't have to have the same name as the directory in the cluster's storage. Mounting a directory in this way essentially creates a "connection" between the directory on the outside of the container (in the cluster's storage) and inside the container. While inside the container, your scripts will be able to see all of the contents of a mounted directory, including other sub-directories.

- `PROJECDIR`, `OUTDIR`, and `NAME` are variables that are used in the `bsub` command to specify the project directory, output directory, and job name.

After defining important variables, there is a multi-line `bsub` command that actually submits the job. It has several arguments:

- `-G` is the compute group (usually belonging to the lab PI) that the job belongs to.

- `-q` is the queue that the job will join. The `general` queue is non-interactive.

- `-n`, `-M`, and `-R` specify the amount of memory that the job will use.

- `-cwd` sets the working directory inside the Docker container. In this example, note that we use the project directory that we mounted. This is useful because, when the job runs, it will look in this directory for scripts.

- `-J` gives the job a name. This is not strictly necessary, but it is helpful for keeping track of running jobs.

- `-o` creates an output file for the job. Your scripts may save certain products to other files, but this file will record the standard output, including possible job failures.

- `-a` is the most important part of the `bsub` command. There are 3 parts.

   - `'docker(sswiston/rb_tp:4)'` is the Docker image being used. The image will be pulled from Docker Hub.

   - `/bin/bash` is the initial command that will run once the container is open.

   - `/project/rev_shell.sh` is the script that will run with the `/bin/bash` command.

You may wonder why we don't immediately call RevBayes and run a `.Rev` script. This is possible to do. However, the Wustl RIS cluster overwrites the `PATH` variable inside the Docker container, which means that RevBayes can't be found with a simple `rb` command. Instead, you would have to specify the full filepath to the RevBayes binary inside the container, which is `/revbayes/projects/installer/rb`. You may also want to add extra information to the `rb` command (like defining variables for your analyses). It can be easier to use a shell script to call RevBayes while inside the container. Here is an example:

```
PATH=$PATH:/revbayes/projects/installer:/revbayes/projects/installer/rb

rb_command="variable_1="test";source(\"/project/rev_script.Rev\");"
echo $rb_command | rb
```

In this short script, RevBayes is added to the `PATH` variable inside the container. Then a RevBayes command is constructed. It has two parts: setting `variable_1` to have a value of `test`, and sourcing the script `rev_script.Rev`. The final line pipes this command into RevBayes, which sets `variable_1` equal to `test` and runs `rev_script.Rev`.

This example highlights two main differences between using the RevBayes Docker image on your local machine and using it on the Wustl RIS computing cluster. First, the analyses must be submitted as jobs (common amongst computing clusters). Second, the job submission process overwrites the `PATH` variable inside the Docker container, so you will have to know where to find the programs you want to use. Other computing clusters may have similar challenges. Before running lengthy jobs or batches of jobs, it is recommended that you try out a test job or two and make sure they work as expected. Generally, the Docker image will function the same on any platform, and all of the programs should run correctly with appropriate input scripts.