FROM ubuntu:20.04 as scratch

ARG UPDATEDATE=032621-1

ARG TZ=America/Los_Angeles
ARG DUMP978VER=0.5
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git \
      build-essential \
      libboost-system-dev \
      libboost-program-options-dev \
      libboost-regex-dev \
      libboost-filesystem-dev && \
    rm -rf /var/lib/apt/lists/*

ARG DUMP978_VERSION=4.0
ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
RUN git clone https://github.com/flightaware/dump978.git /dump978
WORKDIR /dump978
RUN git fetch --all --tags && git checkout tags/v$DUMP978_VERSION
RUN CXXFLAGS=$CFLAGS make skyaware978

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      libboost-program-options1.71.0 \
      libboost-filesystem1.71.0 \
      libboost-regex1.71.0 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=scratch /dump978/skyaware978 /usr/bin/skyaware978
RUN mkdir -p /html/skyaware978
COPY --from=scratch /dump978/skyaware/ /html/skyaware978
RUN mkdir -p /json-data/skyaware978

ENTRYPOINT ["/usr/bin/skyaware978"]
CMD ["--connect", "dump978:30978", "--reconnect-interval", "30", "--json-dir", "/json-data/skyaware978", "--history-count", "120", "--history-interval", "30", "--lat", "<receiver latitude>", "--lon", "<receiver longitude>"]
