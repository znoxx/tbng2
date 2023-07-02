FROM tbng-common

ARG I2P_VERSION=xxx

RUN apt-get install -y supervisor procps expect bash && \
    apt-get  install -y openjdk-17-jdk && \
    apt-get update --fix-missing && \
    apt-get install -f && \
    apt-get install openjdk-17-jdk && \ 
    apt-get autoremove && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -r i2p-tbng && useradd -r -g i2p-tbng i2p-tbng && \
    mkdir /home/i2p-tbng 


ADD https://files.i2p-projekt.de/${I2P_VERSION}/i2pinstall_${I2P_VERSION}.jar /home/i2p-tbng/i2pinstall_${I2P_VERSION}.jar
ENV I2P_INITIAL_VERSION=${I2P_VERSION}
ADD i2p-installer.sh /home/i2p-tbng/i2p-installer.sh
ADD start_i2p.sh /home/i2p-tbng/start_i2p.sh
ADD supervisord.conf /home/i2p-tbng/supervisord.conf
RUN chown -R i2p-tbng /home/i2p-tbng

USER i2p-tbng
WORKDIR /home/i2p-tbng

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/home/i2p-tbng/supervisord.conf"]

