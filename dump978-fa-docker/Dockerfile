FROM ubuntu:20.04 as scratch

ARG TZ=America/Los_Angeles
ARG SDRVER=0.6
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git \
      build-essential \
      cmake \
      libusb-1.0-0-dev \
      pkg-config \
      debhelper \
      dh-systemd \
      libboost-system-dev \
      libboost-program-options-dev \
      libboost-regex-dev \
      libboost-filesystem-dev \
      libsoapysdr-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone git://git.osmocom.org/rtl-sdr.git /rtl-sdr
WORKDIR /rtl-sdr
RUN sed -i 's/(0.6)/(0.6.1-special)/g' debian/changelog
ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
RUN CFLAGS=$CFLAGS dpkg-buildpackage -b -us -uc -nc

ARG UPDATEDATE=032621-1

ARG DUMP978_VERSION=5.0
RUN git clone https://github.com/flightaware/dump978.git /dump978
WORKDIR /dump978
RUN git fetch --all --tags && git checkout tags/v$DUMP978_VERSION
RUN CXXFLAGS=$CFLAGS make dump978-fa

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      libusb-1.0-0 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=scratch /librtlsdr0_0.6.1-special_arm64.deb /librtlsdr0_0.6.1-special_arm64.deb
RUN dpkg --install /librtlsdr0_0.6.1-special_arm64.deb
RUN rm /librtlsdr0_0.6.1-special_arm64.deb

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      soapysdr0.7-module-rtlsdr \
      libboost-program-options1.71.0 \
      libboost-regex1.71.0 \
      soapysdr-module-rtlsdr && \
    rm -rf /var/lib/apt/lists/*

COPY --from=scratch /dump978/dump978-fa /usr/bin/dump978-fa

EXPOSE 30978 30979

ENTRYPOINT ["/usr/bin/dump978-fa"]
CMD ["--sdr", "driver=rtlsdr", "--raw-port", "30978", "--json-port", "30979"]
