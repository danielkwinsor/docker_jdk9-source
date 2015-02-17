#Ubuntu -> jdk8-bootstrap -> jdk9-source
#Version 0.1 20150216
FROM danielkwinsor/jdk8-bootstrap
MAINTAINER Daniel Winsor <danielkwinsor@gmail.com>

RUN apt-get update \
    && apt-get install -y \
        git-core \
        mercurial

RUN groupadd -r openjdk \
    && useradd -r -g openjdk openjdk

#from https://java.net/projects/adoptopenjdk/pages/GetSource
ENV HOME /home/openjdk
ENV SOURCE_CODE $HOME/src/

RUN mkdir -p $SOURCE_CODE

#I don't know why COPY and ADD are not working, but I tried everything
RUN cat .bashrc > $HOME/.bashrc
RUN chown -R openjdk:openjdk $HOME
#RUN chown openjdk:openjdk /dev/stdout

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
