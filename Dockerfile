FROM debian:stable-slim

WORKDIR /ddclient

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install ddclient libio-socket-ssl-perl

COPY start.sh ./
RUN chmod +x start.sh

CMD ["/ddclient/start.sh"]