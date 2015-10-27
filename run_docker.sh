#!/bin/bash

docker run -ti -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/developer/.Xauthority -v `pwd`:/home/developer/expresso --net=host expresso $*