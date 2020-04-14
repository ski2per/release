FROM alpine:3.7
#FROM ubuntu:16.04
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

COPY etcd* /usr/bin/
#COPY entrypoint.sh /entrypoint.sh

EXPOSE 2379 2380

ENTRYPOINT ["etcd"]
