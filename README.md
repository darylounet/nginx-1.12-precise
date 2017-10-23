
Dockerfiles for building NGiNX 1.12 for the depreciated LTS Ubuntu Trusty 12.04

[![Build Status](https://travis-ci.org/darylounet/nginx-1.12-precise.svg?branch=master)](https://travis-ci.org/darylounet/nginx-1.12-precise)

If you just want to install built packages, install from this repository :

https://packagecloud.io/DaryL/nginx-1-12-precise

If you want to build packages by yourself, this is for you :

Build Dockerfile usage :

```bash
docker build -t build-nginx-precise --build-arg NGINX_VERSION=1.12.2 .
```

Then :
```bash
docker run build-nginx-precise
docker cp $(docker ps -l -q):/src ~/Downloads/
```

And once you don't need it anymore :
```bash
docker rm $(docker ps -l -q)
```

Get latest nginx version : https://nginx.org/en/download.html
Or :
```bash
curl -s https://nginx.org/packages/ubuntu/dists/xenial/nginx/binary-amd64/Packages.gz |zcat |php -r 'preg_match_all("#Package: nginx\nVersion: (.*?)-\d~.*?\nArch#", file_get_contents("php://stdin"), $m);echo implode($m[1], "\n")."\n";' |sort -r |head -1
```
