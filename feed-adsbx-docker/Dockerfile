FROM ubuntu:20.04 as scratch

ARG UPDATEDATE=032621-1
ARG TZ=America/Los_Angeles
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git \
      build-essential \
      zlib1g-dev \
      ncurses-dev && \
    rm -rf /var/lib/apt/lists/*

ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
RUN git clone https://github.com/adsbxchange/readsb.git /readsb
WORKDIR /readsb
RUN CFLAGS=$CFLAGS make -j3

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      libncurses6 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=scratch /readsb/readsb /usr/bin/feed-adsbx
RUN mkdir -p /run/adsbexchange-feed

ENTRYPOINT ["/usr/bin/feed-adsbx"]
CMD ["--net", "--net-only", "--debug=n", "--quiet", "--write-json", "/run/adsbexchange-feed", "--net-beast-reduce-interval", "0.5", "--net-connector", "feed.adsbexchange.com,30005,beast_reduce_out", "--net-heartbeat", "60", "--net-ro-size", "1280", "--net-ro-interval", "0.2", "--net-ro-port", "0", "--net-sbs-port", "0", "--net-bi-port", "0", "--net-bo-port", "0", "--net-ri-port", "0", "--net-connector", "dump1090,30005,beast_in", "--net-connector", "adsbx-mlat,30157,beast_in"]
