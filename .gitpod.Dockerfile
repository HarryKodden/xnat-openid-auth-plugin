FROM gitpod/workspace-full:latest

USER root

RUN apt-get update && \
    apt-get -y install build-essential libkrb5-dev gcc make gradle openjdk-8-jdk && \
    apt-get clean && \
    apt-get -y autoremove && \
    update-java-alternatives --jre-headless --jre --set /usr/lib/jvm/java-1.8.0-openjdk-amd64

USER gitpod