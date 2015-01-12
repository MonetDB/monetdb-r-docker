#!/bin/bash

if [ -z "$1" ]; then
    # Use the default db
    dbname=db
    if [ -n "$2" ]; then
        password=$2
    else
        echo "No password provided, aborting."
    fi
else
    dbname=$1
    password=$2
fi

if [ "$dbname" != "db" ]; then
    # Create a new directory for the database
    mkdir -p /var/monetdb5/$dbname
fi

# Start the database
sh /root/start-monetdb.sh $dbname
# Wait a bit for the database to start
sleep 5

if [ -n "$password" ]; then
    # Set the new admin password
    sh /root/set-monetdb-password.sh $dbname monetdb $password
fi

echo "MonetDB setup done"
