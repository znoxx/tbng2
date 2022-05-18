FROM debian:stable-slim

ARG I2P_VERSION=1.7.0

RUN apt-get update && apt-get install -y supervisor procps expect bash openjdk-17-jdk-headless ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -r i2p-tbng && useradd -r -g i2p-tbng i2p-tbng && \
    mkdir /home/i2p-tbng 


ADD https://files.i2p-projekt.de/${I2P_VERSION}/i2pinstall_${I2P_VERSION}.jar /home/i2p-tbng/i2pinstall_${I2P_VERSION}.jar
ADD i2p-installer.sh /home/i2p-tbng/i2p-installer.sh
ADD start_i2p.sh /home/i2p-tbng/start_i2p.sh
ADD supervisord.conf /home/i2p-tbng/supervisord.conf
RUN chown -R i2p-tbng /home/i2p-tbng

USER i2p-tbng
WORKDIR /home/i2p-tbng
RUN /home/i2p-tbng/i2p-installer.sh


ENTRYPOINT ["/usr/bin/supervisord", "-c", "/home/i2p-tbng/supervisord.conf"]
