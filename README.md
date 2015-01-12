monetdb-docker
===========================
Dockerfile for [MonetDB with R integration](https://www.monetdb.org/content/embedded-r-monetdb)
Based on CentOS 7*

# Setup

To build the image run
```bash
docker build --rm -t <yourname>/monetdb-docker .
```

# Launching a MonetDB container
```bash
docker run -d -P <yourname>/monetdb-docker
```
The `-d` option will send the docker process to the background. The `-P` option will "publish" all exposed ports.

## Quick start
```bash
docker exec -d <container-id> /root/start-monetdb.sh
```
After that, you should be able to access MonetDB on the default port 50000, with the default username/password: monetdb/monetdb.
Or you can run `docker exec -it <container-id> mclient db` to open an `mclient` shell in the container.

## Production run
Before letting other users use the database-in-container, you should create a new database and set the password for the admin user `monetdb`:
```bash
docker exec -d <container-id> /root/setup-monetdb.sh <dbname> <password>
```
Or should at least set a new admin password:
```bash
docker exec -d <container-id> /root/setup-monetdb.sh <password>
```

After that, you should be able to access MonetDB on the default port 50000, with the default username/password: monetdb/monetdb.
Or you can run `docker exec -it <container-id> mclient db` to open an `mclient` shell in the container.

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
MonetDB runs on port 50000 by default, which is exposed on the image.
