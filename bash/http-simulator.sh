#!/usr/bin/env bash

HOSTS=(
"a.ted.com"
"b.ted.com"
"c.ted.com"
)

function generate_rand_str {
    RAND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
}



for host in "${HOSTS[@]}";do
    echo $host
    for i in {1..3};do
        generate_rand_str
        curl -s -o /dev/null -H "Host: $host" "http://127.0.0.1/$RAND"
        #sleep 1
    done
done

