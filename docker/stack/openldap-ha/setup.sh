#!/bin/bash



MODS=("cosine" "nis" "inetorgperson")
INCLUDE_TPL='include: file:///usr/local/etc/openldap/schema/'
TPL='include: file://'

cp /usr/local/etc/openldap/slapd.ldif /tmp
line_no=$(grep -n "$TPL" /tmp/slapd.ldif | awk -F':' '{print $1}')

for mod in ${MODS[@]};do
    line="$INCLUDE_TPL$mod.ldif"
    echo $line
    sed -i -e "#${TPL}# i\"${line}\"" /tmp/slapd.ldif
    #sed -i -e "${line_no}a${line}" /tmp/slapd.ldif
    
done
env | grep 'LDAP'


mkdir -p /usr/local/var/openldap-data
mkdir -p /usr/local/etc/slapd.d

