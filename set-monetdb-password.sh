#!/bin/bash

dbname="db"
username="monetdb"

if [ -n "$1" ]; then
    password=$1
    echo "Setting new password for database '$dbname' and user '$username'."
    echo -e "user=monetdb\npassword=monetdb" > .monetdb
    mclient $dbname -s "ALTER USER SET PASSWORD '$password' USING OLD PASSWORD 'monetdb'";
    rm -f .monetdb
else
    echo "No password provided, aborting."
fi
