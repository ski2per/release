FROM ubuntu:16.04
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

ARG ver=2.4.46
ARG openldap=openldap-${ver}

COPY sources.list /etc/apt
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl build-essential gcc make groff groff-base libltdl-dev build-essential


# Enable line below and download openldap source under same directory
COPY ${openldap}.tgz /tmp

RUN cd /tmp && \
    #curl -O ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/${openldap}.tgz && \
    tar -zxf ${openldap}.tgz && \
    cd ${openldap} && \
    ./configure --enable-bdb=no --enable-hdb=no  && \
    make depend && \
    make && \
    make install

RUN  rm -rf /var/lib/apt/lists
