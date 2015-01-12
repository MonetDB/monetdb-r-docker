#!/bin/bash

dbname=$1
if [ -z "$dbname" ]; then
    dbname="db"
fi

enabler='embedded_r=true'

mserver5 --dbpath=/var/monetdb5/$dbname --daemon=yes --set $enabler >> /var/monetdb5/$dbname/monetdb.log &
echo "MonetDB started"
