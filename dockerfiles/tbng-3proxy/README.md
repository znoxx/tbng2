# README #

```
docker build . -t 3proxy --build-arg RELEASE=0.9.4 --build-arg ARCH=x86_64
docker run -it --rm -p 8888:8888 -e PROXY_USERNAME=proxyuser -e PROXY_PASSWORD=proxypassword -e AUTH=AUTH 3proxy
docker run -it --rm -p 8888:8888  3proxy
```

