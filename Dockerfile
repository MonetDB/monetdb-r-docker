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
RUN yum install -y epel-release \
                   wget

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
RUN wget -O /etc/yum.repos.d/monetdb.repo https://dev.monetdb.org/downloads/epel/monetdb.repo
RUN rpm --import https://dev.monetdb.org/downloads/MonetDB-GPG-KEY

ARG MonetDBVersion=11.23.13

# Install MonetDB clients
RUN yum install -y MonetDB-stream-$MonetDBVersion \
                   MonetDB-client-$MonetDBVersion \
                   MonetDB-client-tools-$MonetDBVersion \
                   MonetDB-client-odbc-$MonetDBVersion

# Install MonetDB server
RUN yum install -y MonetDB-$MonetDBVersion \
                   MonetDB-SQL-server5-hugeint-$MonetDBVersion

# Install MonetDB extensions
RUN yum install -y MonetDB-geom-MonetDB5-$MonetDBVersion \
                   MonetDB-gsl-MonetDB5-$MonetDBVersion \
                   MonetDB-R-$MonetDBVersion

# RUN yum install -y MonetDB-lidar-$MonetDBVersion

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
