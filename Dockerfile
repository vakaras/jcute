FROM ubuntu:16.04
MAINTAINER Vytautas Astrauskas "vastrauskas@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Install prerequisites.
RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        unzip \
        wget \
        curl \
        gdebi-core \
        build-essential \
        && \
    apt-get clean

# Install Java.
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer libxext-dev libxrender-dev libxtst-dev mercurial && \
    apt-get install -y libgtk2.0-0 libcanberra-gtk-module && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install lp-solve and its Java wrapper.
RUN apt-get install -y lp-solve liblpsolve55-dev && \
    apt-get clean && \
    cd /tmp && \
    wget 'https://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip' -O lp_solve.zip && \
    unzip lp_solve.zip && \
    cd lp_solve_*_java && \
    cp lib/ux64/liblpsolve55j.so /usr/lib/lp_solve/ && \
    cp lib/lpsolve55j.jar /usr/lib/jvm/java-7-oracle/jre/lib/ext/ && \
    ldconfig && \
    cd && rm -rf /tmp/*
ENV LD_LIBRARY_PATH /usr/lib/lp_solve/

# Install fish.
RUN apt-get update && \
    apt-get install -y sudo man-db fish && \
    apt-get clean

# Bug work arounds.
RUN locale-gen en_US.UTF-8
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/usr/bin/fish" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/bin/fish
