FROM debian:stable-slim
ARG RELEASE=0.9.4
ARG ARCH=unknown
ENV AUTH=OPEN
ADD https://github.com/3proxy/3proxy/releases/download/$RELEASE/3proxy-$RELEASE.$ARCH.deb /tmp/
RUN apt-get update && apt-get install --no-install-recommends curl ca-certificates -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN dpkg -i /tmp/3proxy-$RELEASE.$ARCH.deb
RUN chmod a+x /etc/3proxy/conf/add3proxyuser.sh
RUN useradd -ms /bin/bash 3proxy
ADD entrypoint.sh /entrypoint.sh
ADD 3proxy.common /conf/3proxy.common
ADD 3proxy.auth /conf/3proxy.auth   
ADD 3proxy.noauth /conf/3proxy.noauth 
ADD entrypoint.sh /entrypoint.sh
RUN chown -R 3proxy:3proxy /conf
RUN rm -f /tmp/3proxy-$RELEASE.$ARCH.deb
USER 3proxy
WORKDIR /home/3proxy
ENTRYPOINT ["/entrypoint.sh"]
