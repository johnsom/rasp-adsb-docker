FROM ubuntu:20.04

ARG TZ=America/Los_Angeles

ARG UPDATEDATE=032621-1
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      nginx && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /nginx.conf
COPY mime.types /mime.types

RUN mkdir -p /var/lib/collectd
RUN mkdir -p /usr/share/graphs1090/html

EXPOSE 80

ENTRYPOINT ["nginx"]
CMD ["-c", "/nginx.conf"]
