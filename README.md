monetdb-r-docker
===========================
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/monetdb/monetdb-r-docker/)

Docker container for [MonetDB with R](https://www.monetdb.org/content/embedded-r-monetdb). Based on CentOS 7.

# Supported tags and respective Dockerfile links
* [`Jul2017`, `11.27.1`, `latest` (Dockerfile)](https://github.com/MonetDB/monetdb-r-docker/blob/jul2017/Dockerfile)
* [`Dec2016-SP5`, `11.25.23`, (Dockerfile)](https://github.com/MonetDB/monetdb-r-docker/blob/dec2016-sp5/Dockerfile)
* [`Dec2016-SP4`, `11.25.21`, (Dockerfile)](https://github.com/MonetDB/monetdb-r-docker/blob/dec2016-sp4/Dockerfile)
* [`Dec2016-SP3`, `11.25.15`, (Dockerfile)](https://github.com/MonetDB/monetdb-r-docker/blob/dec2016-sp3/Dockerfile)
* [`Dec2016-SP2`, `11.25.9`, (Dockerfile)](https://github.com/MonetDB/monetdb-r-docker/blob/dec2016-sp2/Dockerfile)
* [`Dec2016-SP1`, `11.25.5` (Dockerfile)](https://github.com/MonetDB/monetdb-r-docker/blob/dec2016-sp1/Dockerfile)

# Launching a MonetDB container
Pull the image from the registry:

```
docker pull monetdb/monetdb-r-docker
```

## Quick start
```
docker run -d -P -p 50000:50000 --name monetdb-r monetdb/monetdb-r-docker
```
The `-d` option will send the docker process to the background. The `-P` option will publish all exposed ports.

After that, you should be able to access MonetDB on the default port `50000`, with the default username/password: `monetdb/monetdb`.

Or you can run `docker exec -it monetdb-r mclient db` to open an [`mclient`](https://www.monetdb.org/Documentation/mclient-man-page) shell in the container.

## Production run
Before letting other users access the database-in-container, you should set a new password for the admin user `monetdb`:

```
docker exec -d monetdb-r /root/set-monetdb-password.sh <password>
```

# Advanced
## Multiple database servers per container
The MonetDB daemon [monetdbd](https://www.monetdb.org/Documentation/monetdbd-man-page) allows for multiple MonetDB database server processes to run on the same system and listed on the same port. While it is not advised to run more than one database server in the same Docker container, you can do that by creating a new database with the [monetdb](https://www.monetdb.org/Documentation/monetdb-man-page) command-line control tool. In this container, the database server is controller by the MonetDB daemon (`monetdbd`), both of which are started by `supervisord`.

For more information on how to use MonetDB, check out the [tutorial](https://www.monetdb.org/Documentation/UserGuide/Tutorial).

## Build your own
You can use the image as a base image when building your own version.
After pulling the image from the registry, run the command bellow to build and tag your own version.

```
docker build --rm -t <yourname>/monetdb-r-docker .
```

# Details
## Base image
The MonetDB image is based on the CentOS 7. We migrated from Fedora (latest).
## Software
The image includes the latest stable version of the software available for CentOS at build time:
* MonetDB server with hugeint support
* R module for embedded R support
* Python2 module for embedded Python support (since Dec2016 only)
* GEOS module
* GSL module
* Mclient - The native MonetDB client
* MonetDB ODBC driver

The default database on the image has R and Python2 integration enabled.

## Ports
MonetDB runs on port `50000` by default, which is exposed on the image.
