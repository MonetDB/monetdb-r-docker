#!/bin/bash

function test_monetdb_connection() {
  runuser -l  monetdb -c "mclient -d db -s 'SELECT 1'" &> /dev/null
  local status=$?
  if [ $status -ne 0 ]; then
    return 0
  fi
  return 1
}

chown -R monetdb:monetdb /var/monetdb5
cd /home/monetdb

if [ ! -d "/var/monetdb5/dbfarm" ]; then
    runuser -l  monetdb -c 'monetdbd create /var/monetdb5/dbfarm'
else
    echo "Existing dbfarm found in '/var/monetdb5/dbfarm'"
fi
runuser -l  monetdb -c 'monetdbd start /var/monetdb5/dbfarm'
sleep 5
if [ ! -d "/var/monetdb5/dbfarm/db" ]; then
    runuser -l  monetdb -c 'monetdb create db && \
        monetdb set embedr=true db && \
        monetdb release db'
else
    echo "Existing database found in '/var/monetdb5/dbfarm/db'"
fi
runuser -l  monetdb -c 'monetdb start db'

for i in {30..0}; do
  echo 'Testing MonetDB connection ' $i
  if test_monetdb_connection ; then
      echo 'Waiting for MonetDB to start...'
      sleep 1
  else
      echo 'MonetDB is running'
      break
  fi
done
if [ "$i" = 0 ]; then
    echo >&2 'MonetDB startup failed'
    exit 1
fi

mkdir -p /var/log/monetdb
chown -R monetdb:monetdb /var/log/monetdb

echo "Initialization done"
