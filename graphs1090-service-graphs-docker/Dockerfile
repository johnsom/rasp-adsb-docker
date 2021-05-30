FROM ubuntu:20.04 as scratch

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
      rrdtool \
      sed && \
    apt upgrade -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/graphs1090/html
COPY --from=scratch /graph1090/boot.sh /usr/share/graphs1090
COPY --from=scratch /graph1090/graphs1090.sh /usr/share/graphs1090
COPY --from=scratch /graph1090/rem_rra.sh /usr/share/graphs1090
COPY --from=scratch /graph1090/LICENSE /usr/share/graphs1090
COPY --from=scratch /graph1090/scatter.sh /usr/share/graphs1090
COPY --from=scratch /graph1090/service-graphs1090.sh /usr/share/graphs1090
COPY --from=scratch /graph1090/html/* /usr/share/graphs1090/html/
COPY --from=scratch /graph1090/default /etc/default/graphs1090
RUN chmod u+x /usr/share/graphs1090/*.sh
RUN sed -i -e "s/__cache_version__/$(date +%s | tail -c5)/g" /usr/share/graphs1090/html/index.html
# RUN sed -i -e "s#&>/dev/null##g" /usr/share/graphs1090/service-graphs1090.sh
RUN mkdir -p /var/lib/collectd/rrd/localhost/dump1090-localhost
RUN mkdir -p /run/graphs1090

ENTRYPOINT ["/usr/share/graphs1090/service-graphs1090.sh"]
