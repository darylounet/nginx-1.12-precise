#!/bin/bash

NGINX_VERSION=`curl -s https://nginx.org/packages/ubuntu/dists/xenial/nginx/binary-amd64/Packages.gz |zcat |php -r 'preg_match_all("#Package: nginx\nVersion: (.*?)-\d~.*?\nArch#", file_get_contents("php://stdin"), $m);echo implode($m[1], "\n")."\n";' |sort -r |head -1`

docker build -t build-nginx-precise --build-arg NGINX_VERSION=${NGINX_VERSION} .
