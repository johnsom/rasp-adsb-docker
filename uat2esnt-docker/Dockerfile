FROM ubuntu:20.04 as scratch

ARG UPDATEDATE=032621-1
ARG TZ=America/Los_Angeles
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git \
      build-essential && \
    rm -rf /var/lib/apt/lists/*

ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
RUN git clone https://github.com/flightaware/dump978.git /dump978
WORKDIR /dump978/legacy
RUN CFLAGS=$CFLAGS make uat2esnt

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      bash \
      socat && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY --from=scratch /dump978/legacy/uat2esnt /usr/bin/uat2esnt

ENTRYPOINT ["/run.sh"]
