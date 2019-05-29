#!/bin/bash

# set -x

INCLUDE_MODS=("cosine" "nis" "inetorgperson")
INCLUDE_TPL='include: file:///usr/local/etc/openldap/schema/'
#SLAPD_LDIF=/usr/local/etc/openldap/slapd.ldif
TMP_LDIF=/tmp/slapd.ldif
SLAPD_LDIF=slapd.ldif

function update_slapd_ldif {
    tpl='include: file://'
    
    if [ ! -e $SLAPD_LDIF ];then
        echo "Can not found: $SLAPD_LDIF"
        exit 1
    fi

    cp $SLAPD_LDIF $TMP_LDIF
    line_no=$(sed -n "\#$tpl#{=;q}" $TMP_LDIF)

    # Insert inclue lines in slapd.ldif
    # ====================================
    for mod in ${INCLUDE_MODS[@]};do
        line="$INCLUDE_TPL$mod.ldif"
        sed -i "$line_no a \\$line" $TMP_LDIF
        ((line_no++))
    done

    # Replace domain in slapd.ldif
    # ====================================

    # Split domain component in array
    dcs=(${LDAP_DOMAIN//./ })

    for dc in ${dcs[@]};do
         suffix="$suffix,dc=$dc"
    done

    suffix=${suffix#","}

    olcSuffix_line="olcSuffix: $suffix"
    olcRootDN_line="olcRootDN: cn=admin,$suffix"

    line_no=$(sed -n "/olcSuffix/{=;q}" $TMP_LDIF)
    sed -i "${line_no}d" $TMP_LDIF
    # Replace olcSuffix line
    sed -i "$line_no i \\$olcSuffix_line" $TMP_LDIF

    line_no=$(sed -n "/olcRootDN/{=;q}" $TMP_LDIF)
    sed -i "${line_no}d" $TMP_LDIF
    # Replace olcRootDN line
    sed -i "$line_no i \\$olcRootDN_line" $TMP_LDIF


    # Init admin password
    # ====================================
    SLAP_PASSWD_BIN=$(which slappasswd)
    LDAP_ADMIN_PASSWORD=admin
    if [ "$SLAP_PASSWD_BIN" == "" ];then
        olcRootPW_line="olcRootPW: $LDAP_ADMIN_PASSWORD"
    else
        echo $SLAP_PASSWD_BIN
        password_digest=$(slappasswd -n -s $LDAP_ADMIN_PASSWORD)
        olcRootPW_line="olcRootPW: $password_digest"
    fi

    line_no=$(sed -n "/olcRootPW/{=;q}" $TMP_LDIF)
    sed -i "${line_no}d" $TMP_LDIF
    # Replace olcRootPW line
    sed -i "$line_no i \\$olcRootPW_line" $TMP_LDIF
}

function debug {
    echo "debug"
}

function main {
    update_slapd_ldif
    #debug
}
    #mkdir -p /usr/local/var/openldap-data
    #mkdir -p /usr/local/etc/slapd.d
main
