FROM tbng-common
ARG ARCH=unknown
ADD https://github.com/bol-van/zapret/raw/master/binaries/$ARCH/nfqws /usr/local/bin/
ADD entrypoint.sh /
RUN chmod +x /usr/local/bin/nfqws /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
