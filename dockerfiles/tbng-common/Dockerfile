FROM debian:bookworm-slim
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg wget
ADD tor.list /etc/apt/sources.list.d/
RUN wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null
RUN apt-get update && apt-get install --no-install-recommends -y deb.torproject.org-keyring


