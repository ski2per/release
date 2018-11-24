FROM ubuntu:16.04
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

ARG ldapver=2.4.46
RUN getconf LONG_BIT

RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential gcc make groff groff-base libltdl-dev build-essential

USER root
#WORKDIR /root
COPY openldap-${ldapver}.tgz /tmp
RUN cd /tmp && \
    tar -zxf openldap-${ldapver}.tgz && \
    cd openldap-${ldapver} && \
    ./configure --prefix=/usr/local/openldap --enable-bdb=no --enable-hdb=no  && \
    make depend && \
    make && \
    make install

