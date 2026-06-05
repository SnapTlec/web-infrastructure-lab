#!/bin/bash
openssl req -x509 \
            -nodes \
            -days 365 \
            -newkey rsa:2048 \
            -keyout haproxy.tsk \
            -out haproxy.ts \
            -config openssl.cnf