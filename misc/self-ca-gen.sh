#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Script to auto-generate a self-signed CA,
######                  and issue the server certificate
###### VERSION          v1.0
###### UPDATE           2018/05/24

CA_NAME="rootCA"
# If there's no internal DNS, replace this in hosts file
DOMAIN="domain.com"
SERVER_NAME="nginx"

echo "========================"
echo "Generate $CA_NAME.key..."
echo "========================"
openssl genrsa -out "$CA_NAME.key" 4096

echo "========================"
echo "Generate $CA_NAME.crt..."
echo "========================"
openssl req -x509 -new -nodes -key "$CA_NAME.key" -subj /C=CN/ST=Sichuan/L=Chengdu/O=Self\ CA/CN=$DOMAIN -sha256 -days 3650 -out "$CA_NAME.crt"


echo "============================"
echo "Generate $SERVER_NAME.key..."
echo "============================"
openssl genrsa -out "$SERVER_NAME.key" 2048

echo "============================"
echo "Generate $SERVER_NAME.csr..."
echo "============================"
openssl req -new -key nginx.key -subj /C=CN/ST=Sichuan/L=Chengdu/O=$SERVER_NAME/CN=$DOMAIN -out nginx.csr

echo "Sign $SERVER_NAME.csr to generate $SERVER_NAME.crt"
openssl x509 -req -in "$SERVER_NAME.csr" -CA "$CA_NAME.crt" -CAkey "$CA_NAME.key" -CAcreateserial -out "$SERVER_NAME.crt" -days 365 -sha256
