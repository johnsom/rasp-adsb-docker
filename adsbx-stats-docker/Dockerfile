FROM ubuntu:20.04

ARG UPDATEDATE=032621-1
ARG TZ=America/Los_Angeles
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git \
      curl \
      uuid-runtime \
      jq \
      inotify-tools \
      gzip && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/adsbxchange/adsbexchange-stats.git /adsbexchange-stats
RUN mkdir -p /boot
RUN mkdir -p /run/adsbexchange-stats

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
