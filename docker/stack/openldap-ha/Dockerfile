FROM ubuntu:16.04
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

ARG ver=2.4.46
ARG openldap=openldap-${ver}

ENV LDAP_DOMAIN="example.com"
ENV LDAP_ORGANIZATION="example company"
ENV LDAP_ADMIN_PASSWORD="admin"

# Copy Aliyun repo
COPY sources.list /etc/apt
# Install prerequisites 
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    build-essential \
    curl \
    file \
    gcc \
    groff \
    groff-base \
    libicu-dev \
    libltdl-dev \
    libsasl2-dev \
    libssl-dev \
    make

# Enable line below and download openldap source under same directory
COPY ${openldap}.tgz /tmp

# Build OpenLDAP from source
RUN cd /tmp && \
    #curl -O ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/${openldap}.tgz && \
    tar -zxf ${openldap}.tgz && \
    cd ${openldap} && \
    ./configure --with-threads \
    --enable-modules \
    --enable-monitor \
    --enable-overlays \
    --enable-syncprov \
    --enable-memberof \
    --enable-bdb=no \
    --enable-hdb=no && \
    make depend && \
    make && \
    make install

# Execute setup script
COPY setup.sh /tmp
RUN bash /tmp/setup.sh

EXPOSE 389/tcp
