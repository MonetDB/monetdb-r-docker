############################################################
# Dockerfile to build MonetDB and R images
# Based on CentOS 7
############################################################
FROM centos:7
MAINTAINER Panagiotis Koutsourakis <panagiotis.koutsourakis@monetdbsolutions.com>

#######################################################
# Expose ports
#######################################################
EXPOSE 50000

#######################################################
# Setup supervisord
#######################################################
# Install supervisor
RUN yum install -y python-setuptools
RUN easy_install supervisor
# Create a log dir for the supervisor
RUN mkdir -p /var/log/supervisor
# Copy the config
COPY configs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#############################################################
# Enables repos, update system, install packages and clean up
#############################################################
RUN yum install -y \
    wget \
    nano

RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh epel-release-latest-7*.rpm

# Update & upgrade
RUN yum update -y && \
    yum upgrade -y

#############################################################
# MonetDB installation
#############################################################
# Create users and groups
RUN groupadd -g 5000 monetdb && \
    useradd -u 5000 -g 5000 monetdb

# Enable MonetDB repo
RUN yum install -y http://dev.monetdb.org/downloads/epel/MonetDB-release-epel-1.1-1.monetdb.noarch.rpm
RUN rpm --import http://dev.monetdb.org/downloads/MonetDB-GPG-KEY


# Update & upgrade
RUN yum update -y

# Install MonetDB
RUN yum install -y MonetDB-SQL-server5-hugeint
RUN yum install -y MonetDB-client
# Install the MonetDB/GEOM module
RUN yum install -y MonetDB-geom-MonetDB5
# Install MonetDB/R (R is installed as a dependency)
RUN yum install -y MonetDB-R
# Install MonetDB/GSL module
RUN yum install -y MonetDB-gsl-MonetDB5

# Clean up
RUN yum -y clean all

#######################################################
# Setup MonetDB
#######################################################
# Add helper scripts
COPY scripts/set-monetdb-password.sh /home/monetdb/set-monetdb-password.sh
RUN chmod +x /home/monetdb/set-monetdb-password.sh

# Add a monetdb config file to avoid prompts for username/password
# We will need this one to authenticate when running init-db.sh, as well
COPY configs/.monetdb /home/monetdb/.monetdb

# Copy the database init scripts
COPY scripts/init-db.sh /home/monetdb/init-db.sh
RUN chmod +x /home/monetdb/init-db.sh

# Init the db in a scipt to allow more than one process to run in the container
# We need two: one for monetdbd and one for mserver
# The sript will init the database with using the unpreveledged user monetdb
RUN su -c 'sh /home/monetdb/init-db.sh' monetdb

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
