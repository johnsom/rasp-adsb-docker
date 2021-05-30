FROM ubuntu:20.04 as scratch

ARG TZ=America/Los_Angeles
ARG TAR1090VER=97da097a334907338e614d7dfa89c51264d04a71
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      git && \
   rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/wiedehopf/tar1090.git /tar1090
RUN git clone --depth 1 https://github.com/wiedehopf/tar1090-db.git /git-db
WORKDIR /
RUN export dbver=$(git -C /git-db rev-parse --short HEAD);export tarver="$(git -C /tar1090 rev-parse --short HEAD)_$dbver";  echo "{ \"tar1090Version\": \"$tarver\", \"databaseVersion\": \"$dbver\" }" > "/tar1090/html/version.json"

FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" TZ=$TZ apt install -y \
      jq \
      gzip \
      wget \
      sed && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/share/tar1090/html/db
 
COPY --from=scratch /tar1090/tar1090.sh /usr/local/share/tar1090
RUN sed -i -e 's#SRC_DIR=$2#SRC_DIR=$2\nsource /etc/default/tar1090\n#' /usr/local/share/tar1090/tar1090.sh
RUN chmod u+x /usr/local/share/tar1090/tar1090.sh
COPY --from=scratch /tar1090/LICENSE /usr/local/share/tar1090
COPY --from=scratch /tar1090/README.md /usr/local/share/tar1090
COPY --from=scratch /tar1090/default /etc/default/tar1090
RUN sed -i -e 's#ENABLE_978=no#ENABLE_978=yes#' /etc/default/tar1090
RUN sed -i -e 's#http://127.0.0.1/skyaware978#http://nginx-fa/skyaware978#' /etc/default/tar1090
COPY --from=scratch /tar1090/html/ /usr/local/share/tar1090/html/
COPY --from=scratch /git-db/db/* /usr/local/share/tar1090/html/db2/
RUN echo '' >> /usr/local/share/tar1090/html/config.js
RUN echo 'flightawareLinks = true;' >> /usr/local/share/tar1090/html/config.js
RUN rm -f /usr/local/share/tar1090/html/config.js.gz
RUN sed -i -e 's#let databaseFolder = .*#let databaseFolder = \"db\";#' /usr/local/share/tar1090/html/early.js
RUN sed -i -e "s/tar1090 on github/tar1090 on github ($(date +%y%m%d))/" /usr/local/share/tar1090/html/index.html
RUN gzip -k -9 /usr/local/share/tar1090/html/*.js
RUN gzip -k -9 /usr/local/share/tar1090/html/*.css
RUN gzip -k -9 /usr/local/share/tar1090/html/libs/*.js
RUN gzip -k -9 /usr/local/share/tar1090/html/libs/*.css
#RUN gzip -k -9 /usr/local/share/tar1090/html/ol/*.js
RUN mkdir -p /run/tar1090

ENTRYPOINT ["/usr/bin/bash"]
CMD ["/usr/local/share/tar1090/tar1090.sh", "/run/tar1090", "/json-data/dump1090"]
