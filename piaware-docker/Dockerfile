FROM ubuntu:20.04 as scratch

ARG UPDATEDATE=032621-1
ARG TZ=America/Los_Angeles
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      autoconf \
      build-essential \
      chrpath \
      debhelper \
      devscripts \
      dh-python \
      dh-systemd \
      git \
      libboost-filesystem-dev \
      libboost-program-options-dev \
      libboost-regex-dev \
      libboost-system-dev \
      libdebhelper-perl \
      libssl-dev \
      libz-dev \
      pkg-config \
      python3-dev \
      python3-venv \
      tcl8.6-dev \
      tcl-dev \
      wget && \
    rm -rf /var/lib/apt/lists/*

ARG CFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"
ARG CXXFLAGS="-mcpu=cortex-a72+crypto -mtune=cortex-a72"

# Workaround from version 3.8.1. Should be removed in the future.
RUN git clone http://github.com/flightaware/tcltls-rebuild.git /tcltls-rebuild
WORKDIR /tcltls-rebuild
RUN ./prepare-build.sh buster
WORKDIR /tcltls-rebuild/package-buster
RUN CFLAGS=$CFLAGS dpkg-buildpackage -b

RUN git clone https://github.com/flightaware/tcllauncher.git /tcllauncher
WORKDIR /tcllauncher
RUN autoconf
RUN ./configure --with-tcl=/usr/lib/tcl8.6
RUN CFLAGS=$CFLAGS make

RUN git clone https://github.com/flightaware/dump1090.git /dump1090
WORKDIR /dump1090
RUN CFLAGS=$CFLAGS make faup1090 RTLSDR=no BLADERF=no

RUN git clone https://github.com/flightaware/dump978.git /dump978
WORKDIR /dump978
RUN CXXFLAGS=$CXXFLAGS make faup978

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      make \
      gcc \
      git \
      ca-certificates \
      iproute2 \
      libboost-program-options1.71.0 \
      libboost-regex1.71.0 \
      python3 \
      python3-pip \
      net-tools \
      tclx8.4 \
      tcl8.6 \
      tcllib \
      itcl3 \
      socat \
      wget && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/lib/piaware/helpers
COPY --from=scratch /dump1090/faup1090 /usr/lib/piaware/helpers/faup1090
COPY --from=scratch /dump978/faup978 /usr/lib/piaware/helpers/faup978

RUN git clone https://github.com/mutability/mlat-client.git /mlat-client
WORKDIR /mlat-client
RUN pip3 install .
RUN ln -s /usr/local/bin/fa-mlat-client /usr/lib/piaware/helpers

COPY --from=scratch /tcltls-rebuild/tcl-tls_1.7.16-1+fa1_arm64.deb /tcl-tls_1.7.16-1+fa1_arm64.deb
RUN apt install -y /tcl-tls_1.7.16-1+fa1_arm64.deb

COPY --from=scratch /tcllauncher/tcllauncher /usr/bin/tcllauncher
RUN mkdir -p /usr/lib/Tcllauncher1.10
COPY --from=scratch /tcllauncher/tcllauncher.tcl /usr/lib/Tcllauncher1.10/tcllauncher.tcl
COPY --from=scratch /tcllauncher/tcllauncher-support.tcl /usr/lib/Tcllauncher1.10/tcllauncher-support.tcl
COPY --from=scratch /tcllauncher/pkgIndex.tcl /usr/lib/Tcllauncher1.10/pkgIndex.tcl

ARG PIAWARE_VERSION=5.0
RUN git clone https://github.com/flightaware/piaware.git /piaware
WORKDIR /piaware
RUN git fetch --all --tags && git checkout tags/v$PIAWARE_VERSION
RUN make -C package install
RUN make -C programs/piaware install TCLLAUNCHER=/usr/bin/tcllauncher
RUN make -C programs/piaware-config install TCLLAUNCHER=/usr/bin/tcllauncher
RUN make -C programs/piaware-status install TCLLAUNCHER=/usr/bin/tcllauncher
RUN make -C programs/pirehose install TCLLAUNCHER=/usr/bin/tcllauncher
RUN mkdir -p /run/piaware
RUN touch /etc/piaware.conf

COPY run.sh /

ENTRYPOINT ["/run.sh"]
