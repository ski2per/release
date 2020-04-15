FROM alpine:3.7
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

ARG ver=2.4.46
ARG openldap=openldap-${ver}

ENV LDAP_DOMAIN="ted.com"
ENV LDAP_ORGANIZATION="ted company"
ENV LDAP_ADMIN_PASSWORD="admin"

RUN sed -i s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g /etc/apk/repositories && \
    apk --no-cache add build-base db-dev openssl-dev icu-dev cyrus-sasl-dev groff file libtool

WORKDIR /

COPY ${openldap}.tgz /

RUN tar -zxf ${openldap}.tgz && \
    cd ${openldap} && \
    ./configure --with-threads \
    --enable-modules \
    --enable-monitor \
    --enable-overlays \
    --enable-syncprov \
    --enable-memberof \
    --enable-ppolicy \
    --enable-deref \
    --enable-refint \
    --enable-bdb=no \
    --enable-hdb=no && \
    make depend && \
    make && \
    make install && \
    rm -rf /${openldap}*

#EXPOSE 389/tcp
