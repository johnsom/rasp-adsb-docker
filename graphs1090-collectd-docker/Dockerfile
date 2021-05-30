FROM ubuntu:20.04 as scratch

ARG UPDATEDATE=032621-1
ARG TZ=America/Los_Angeles
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git && \
   rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/wiedehopf/graphs1090.git /graph1090

FROM ubuntu:20.04

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      python3-minimal \
      libpython3.8 \
      rrdtool \
      sed \
      collectd-core && \
    apt upgrade -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/graphs1090
COPY --from=scratch /graph1090/dump1090.db /usr/share/graphs1090
COPY --from=scratch /graph1090/dump1090.py /usr/share/graphs1090
COPY --from=scratch /graph1090/system_stats.py /usr/share/graphs1090
COPY --from=scratch /graph1090/LICENSE /usr/share/graphs1090
COPY --from=scratch /graph1090/collectd.conf /etc/collectd/collectd.conf
RUN sed -i -e 's#URL .*#URL "http://nginx-fa"#' /etc/collectd/collectd.conf
RUN sed -i -e 's#URL_978.*#URL_978 "http://nginx-fa/skyaware978"#' /etc/collectd/collectd.conf
RUN mkdir -p /var/lib/collectd/rrd/localhost/dump1090-localhost
RUN echo "/usr/lib/python3.8/config-3.8-aarch64-linux-gnu/libpython3.8.so" > /etc/ld.so.preload

ENTRYPOINT ["/usr/sbin/collectd"]
CMD ["-f"]
