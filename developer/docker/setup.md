---
title: Setting up Docker
category: docker
order: 0
---

## Setting up Docker

The first step to this is installing [Docker](https://docs.docker.com/get-docker/). For Windows or MacOS this means installing Docker Desktop. For Linux this means installing just regular old Docker. For this tutorial I will also be using [vscode](https://code.visualstudio.com/) which is an open-source editor made by Microsoft (strange as that sentence is for me to type). The tutorial could easily be done in the terminal also (e.g. PowerShell, bash). If you want to use vscode you will also need the [Remote Explorer](https://github.com/Microsoft/vscode-remote-release) extension. If you search remote in the extensions tab its the one called Remote - Containers. This lets us connect our vscode window to the docker container. 

OK now we at least have Docker. We can run the Docker pull (currently this is not hosted on our organization page). Run this command in your terminal:
    docker pull docker.pkg.github.com/wadedismukes/revbayes-dockerfiles/revbayesdockerfiles:ubuntu-latest

This will pull the image down which will take a bit. After this completes you will be able to run a Rev terminal using:
    docker run --rm -it docker.pkg.github.com/wadedismukes/revbayes-dockerfiles/revbayesdockerfiles:ubuntu-latest

If you want a terminal inside of the container you can use:
    docker run -it --entrypoint /bin/bash revbayesdockerfiles:ubuntu-latest

Without any errors you opened either revbayes or a terminal inside the container.

