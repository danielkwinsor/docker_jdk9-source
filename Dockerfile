#Ubuntu -> jdk8-bootstrap -> jdk9-source
#Version 0.3 20150217
FROM dockerfile/java:oracle-java8
MAINTAINER Daniel Winsor <danielkwinsor@gmail.com>

RUN apt-get update \
    && apt-get install -y \
        git-core \
        libasound2-dev \
        libcups2-dev \
        libfreetype6-dev \
        libX11-dev \
        libxext-dev \
        libxrender-dev \
        libxtst-dev \
        libxt-dev \
        mercurial \
        zip

RUN groupadd -r openjdk \
    && useradd -r -g openjdk openjdk

#from https://java.net/projects/adoptopenjdk/pages/GetSource
ENV HOME /home/openjdk
ENV SOURCE_CODE $HOME/src/

RUN mkdir -p $SOURCE_CODE

#I don't know why COPY and ADD are not working, but I tried everything
RUN cat /root/.bashrc > $HOME/.bashrc
RUN chown -R openjdk:openjdk $HOME

WORKDIR $SOURCE_CODE

#USER openjdk
#If I switch user, /dev/stdout is still root
#Thus running get_source.sh below fails.

#One way or another you have to get the source
#I'm choosing to do it now, even though it makes the image larger,
#because then you start with something.
#You may want to `bash get_source.sh` again
RUN hg clone http://hg.openjdk.java.net/jdk9/dev jdk9 \
    && cd jdk9/ \
    && bash get_source.sh

RUN chown -R openjdk:openjdk $SOURCE_CODE
