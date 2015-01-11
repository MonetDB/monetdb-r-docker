#!/bin/bash

dbname=$1
password=$2

# Start monetdbd
monetdbd start /var/monetdb5/dbfarm

if [ -n "$dbname" ] && [ -n "$password" ]; then
    # Use the defaults, just start the database
    monetdb start db
    monetdb release db
else
    if [ -n "$dbname" ] || [ "$dbname"=="db" ]; then
        # Only set a new passoword
        # Start the database
        monetdb start db
        # Set the new admin password
        sh set-monetdb-password.sh db monetdb $password
        # Release the database
        monetdb release db
    else
        # Setup a new database
        # Delete the default database
        monetdb destroy db
        # Create the database and enable R integration
        monetdb create $dbname
        monetdb set embedr=true $dbname
        # Start the database
        monetdb start $dbname
        # Set the new admin password
        sh set-monetdb-password.sh $dbname monetdb $2
        # Release the database
        monetdb release $dbname
    fi
fi
echo "MonetDB started"
