FROM tbng-common

EXPOSE 8118

RUN apt-get install --no-install-recommends -y privoxy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -r privoxy-tbng && useradd -r -g privoxy-tbng privoxy-tbng && mkdir -p /opt/privoxyconf && chown -R privoxy-tbng /opt/privoxyconf

USER privoxy-tbng

VOLUME /opt/privoxyconf

ENTRYPOINT ["/usr/sbin/privoxy", "--no-daemon", "/opt/privoxyconf/config"]


