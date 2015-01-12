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
    echo "Setting new password for database '$dbname' and user '$username'."
    echo -e "user=monetdb\npassword=monetdb" > .monetdb
    mclient $dbname -s "ALTER USER SET PASSWORD '$password' USING OLD PASSWORD 'monetdb'";
    rm -f .monetdb
else
    echo "No password provided, aborting."
fi
