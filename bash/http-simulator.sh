#!/usr/bin/env bash

HOSTS=(
"a.ted.com"
"b.ted.com"
"c.ted.com"
)

function generate_rand {
    RAND_STR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
    RAND_NO=$(cat /dev/urandom | tr -dc '0-9' | fold -w 1 | head -n 1)
}



for host in "${HOSTS[@]}";do
    echo "$host"
    for ((i=0; i<=RAND_NO; i++));do
        generate_rand
        curl -s -o /dev/null -H "Host: $host" "http://127.0.0.1/$RAND_STR"
        #sleep 1
    done
done

