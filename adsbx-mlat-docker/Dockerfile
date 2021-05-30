FROM ubuntu:20.04

ARG UPDATEDATE=032621-1
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git \
      gcc \
      python3-dev \
      python3 && \
    rm -rf /var/lib/apt/lists/*

ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
RUN git clone https://github.com/adsbxchange/mlat-client.git /mlat-client
WORKDIR /mlat-client
RUN CFLAGS=$CFLAGS ./setup.py install

EXPOSE 30157 31003

ENTRYPOINT ["/usr/local/bin/mlat-client"]
