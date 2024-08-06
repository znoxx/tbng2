FROM tbng-common
ARG ARCH=unknown
ADD https://github.com/bol-van/zapret/raw/master/binaries/$ARCH/tpws /usr/local/bin/
ADD entrypoint.sh /
RUN chmod +x /usr/local/bin/tpws /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
