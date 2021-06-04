FROM ubuntu:18.04

LABEL maintainer william.jones@embecosm.com

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y build-essential octave