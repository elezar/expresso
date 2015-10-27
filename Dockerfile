# Start with the CAFFE base image
# TODO: Ensure that this is compatible with Expresso
FROM kaixhin/caffe
MAINTAINER evan.lezar@zalando.de

RUN apt-get update

RUN apt-get install -y x-window-system
RUN apt-get install -y python-numpy
RUN apt-get install -y python-pip
RUN apt-get install -y python-leveldb
RUN apt-get install -y python-skimage
RUN apt-get install -y wget

WORKDIR /root/caffe
RUN make pycaffe

# Add a user "developer".
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

WORKDIR /root/expresso
ADD install.sh /root/expresso/install.sh

# In docker we don't need to use sudo, and must supply the -y flag.
RUN sed -i 's/sudo apt-get install/apt-get install -y/g' install.sh
RUN sed -i 's/sudo pip install/pip install/g' install.sh
RUN sh install.sh

ENV HOME /home/developer

# TODO: This is a bit of a hack to get caffe available to the user "developer"
RUN chmod o+r -R /root/caffe
RUN rsync -avz /root/caffe $HOME

ENV CAFFE_ROOT=$HOME/caffe
ENV EXPRESSO_ROOT=$HOME/expresso

RUN chown 1000:1000 -R $CAFFE_ROOT
RUN mkdir $EXPRESSO_ROOT

# See: http://wiki.ros.org/docker/Tutorials/GUI
ENV QT_X11_NO_MITSHM 1

USER developer
WORKDIR $EXPRESSO_ROOT

CMD sh run_expresso.sh