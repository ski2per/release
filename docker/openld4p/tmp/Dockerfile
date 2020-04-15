FROM openld4p:ted
LABEL MAINTAINER="Ted <ski2per@gmail.com>"

COPY slapd.d /usr/local/etc/openldap

ENTRYPOINT ["/usr/local/libexec/slapd", "-h ldap:/// ldapi:/// ldaps:///", "-F /usr/local/etc/openldap/slapd.d"]
