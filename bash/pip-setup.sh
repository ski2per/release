#!/usr/bin/env bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"

PIP_URL="https://bootstrap.pypa.io/get-pip.py"

curl -O $PIP_URL && python get-pip.py
