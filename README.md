monetdb-docker
===========================
Dockerfile for [MonetDB with R integration](https://www.monetdb.org/content/embedded-r-monetdb)
Based on CentOS 7*

# Setup

To build the image run
```bash
docker build --rm -t <yourname>/monetdb-docker .
```

# Launching MonetDB
## Quick start
```bash
docker run --rm <yourname>/monetdb-docker
```
You can then access MonetDB on the default port 50000, with the default username/password: monetdb/monetdb.

## Production run
You can create a new database and set the password for the admin user `monetdb`, by setting `DBNAME` and `PASSWORD` variables.
You may also simply set a new admin password for the default database `db`, if you do not want to create a new one.

```bash
docker run --rm -e 'PASSWORD=password' -e 'DBNAME=my_database' <yourname>/monetdb-docker
```

# Connecting to MonetDB
To connect to the database:
```bash
mclient -d <database> -u monetdb
```
Omitted here are the default port (50000) and host (localhost).

# Details
## Base image
The MonetDB image is based on CentOS 7. Due to compatibility issues of the MonetDB rpm with the `fakesystemd` installed on the CentOS image, we were forced to use the alternative `milcom/centos7-systemd`, which is the same as the original by with `systemd`.
## Software
The image includes the latest stable version (at the time of image generation) of:
* MonetDB
* GEOS module
* R integration module
* R
The default database on the image, as well as databases created with the startup script, have R integration enabled.

## Ports
MonetDB runs on port 50000 by default, which is open on the image.
