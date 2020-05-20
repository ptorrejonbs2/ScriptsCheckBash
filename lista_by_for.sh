#!/bin/bash

LISTA=$(cat listahost.csv)
for IP in $LISTA; do
    echo "$IP"
done
