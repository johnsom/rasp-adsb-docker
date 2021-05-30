FROM ubuntu:20.04 as scratch

ARG TZ=America/Los_Angeles
ARG SDRVER=0.6
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      gcc \
      git \
      cmake \
      make \
      build-essential \
      debhelper \
      libusb-1.0-0-dev \
      ncurses-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/*

RUN git clone git://git.osmocom.org/rtl-sdr.git /rtl-sdr
WORKDIR /rtl-sdr
ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
RUN CFLAGS=$CFLAGS dpkg-buildpackage -b -us -uc -nc
RUN dpkg --install /librtlsdr-dev_0.6_arm64.deb /librtlsdr0_0.6_arm64.deb

ARG UPDATEDATE=032621-1

ARG DUMP1090VER=dev
RUN git clone https://github.com/flightaware/dump1090.git /dump1090
WORKDIR /dump1090
RUN git checkout $DUMP1090VER
RUN CFLAGS=$CFLAGS make BLADERF=no

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      libncurses6 \
      libusb-1.0-0 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=scratch /librtlsdr0_0.6_arm64.deb /librtlsdr0_0.6_arm64.deb
RUN dpkg --install /librtlsdr0_0.6_arm64.deb
RUN rm /librtlsdr0_0.6_arm64.deb

COPY --from=scratch /dump1090/dump1090 /usr/bin/dump1090
RUN mkdir -p /etc/dump1090

COPY --from=scratch /dump1090/wisdom/wisdom.aarch64.pi4b /etc/dump1090
RUN mkdir -p /html/dump1090/public_html

COPY --from=scratch /dump1090/public_html/ /html/dump1090/public_html/
# fixes https://github.com/jeanralphaviles/dump1090-docker/issues/2
RUN echo '{"type": "dump1090-docker"}' > /html/dump1090/public_html/status.json && \
    echo '{"rings": []}' > /html/dump1090/public_html/upintheair.json

RUN mkdir -p /json-data/dump1090

EXPOSE 30001 30002 30003 30004 30005 30104

ENTRYPOINT ["/usr/bin/dump1090"]
CMD ["--quiet", "--net", "--write-json", "/run/dump1090", "--modeac", "--wisdom", "/etc/dump1090/wisdom.aarch64.pi4b"]
