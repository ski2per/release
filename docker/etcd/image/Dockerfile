FROM alpine:3.7
#FROM ubuntu:16.04
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

COPY etcd /usr/bin/
EXPOSE 2379

ENTRYPOINT ["/usr/bin/etcd"]
#CMD ["/usr/bin/etcd"]
