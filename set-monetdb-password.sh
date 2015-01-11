#!/bin/bash

if [ -n "$1" ]; then
    dbname=$1
else
    dbname="db"
fi

if [ -n "$2" ]; then
    username=$2
else
    username="monetdb"
fi

if [ -n "$3" ]; then
    password=$3
    mclient $dbname -s "ALTER USER SET PASSWORD '$password' USING OLD PASSWORD 'monetdb'";
    echo -e "user=monetdb\npassword=$password" > .monetdb
fi
