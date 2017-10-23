# Dockerfile for building NGiNX 1.12 for Ubuntu Precise
#
# Usage :
#   docker build -t build-nginx-precise --build-arg NGINX_VERSION=1.12.2 .
#
# Then :
#
#   docker run build-nginx-precise
#   docker cp $(docker ps -l -q):/src ~/Downloads/
# And once you don't need it anymore :
#   docker rm $(docker ps -l -q)
#
# Latest nginx version : https://nginx.org/en/download.html
# Or :
# curl -s https://nginx.org/packages/ubuntu/dists/xenial/nginx/binary-amd64/Packages.gz |zcat |php -r 'preg_match_all("#Package: nginx\nVersion: (.*?)-\d~.*?\nArch#", file_get_contents("php://stdin"), $m);echo implode($m[1], "\n")."\n";' |sort -r |head -1

FROM ubuntu:precise
MAINTAINER Cyril Aknine "caknine@clever-age.com"

ENV TZ=Europe/Paris

RUN apt-get update && apt-get --no-install-recommends --no-install-suggests -y install \
    wget ca-certificates curl openssl gnupg2 apt-transport-https \
    unzip make libpcre3-dev zlib1g-dev build-essential devscripts libdistro-info-perl \
    debhelper quilt lsb-release libssl-dev lintian gcc-mozilla libparse-debcontrol-perl

ARG NGINX_VERSION=1.12.2
ARG CHANGELOG_MSG="Updated Upstream."

WORKDIR /root

RUN wget -qO - https://nginx.org/packages/ubuntu/pool/nginx/n/nginx/nginx_1.12.0-1~precise.debian.tar.gz | tar zxvf -
RUN wget -qO - https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar zxvf -
RUN wget http://nginx.org/packages/ubuntu/pool/nginx/n/nginx/nginx_${NGINX_VERSION}.orig.tar.gz

#COPY debian nginx-${NGINX_VERSION}/debian
RUN mv debian nginx-${NGINX_VERSION}/
RUN cd nginx-${NGINX_VERSION}/debian && \
    dch -M -v ${NGINX_VERSION}-1~precise --distribution "precise" "${CHANGELOG_MSG}";

RUN cd nginx-${NGINX_VERSION} && dpkg-buildpackage

RUN ls -la

RUN mkdir /src && mv nginx*.deb /src/ && cp nginx-${NGINX_VERSION}/debian/changelog /src/
RUN dpkg -c /src/nginx_*.deb

RUN dpkg -i /src/nginx_*.deb
RUN dpkg -r nginx
RUN dpkg -P nginx
