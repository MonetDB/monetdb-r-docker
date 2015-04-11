############################################################
# Dockerfile to build MonetDB container images
# Based on Fedora (latest)
############################################################

FROM fedora:latest
MAINTAINER Dimitar Nedev, dimitar.nedev@monetdbsolutions.com

#############################################################
# Enables repos, update system, install packages and clean up
#############################################################
# Enable MonetDB repo
RUN yum install -y https://dev.monetdb.org/downloads/Fedora/MonetDB-release-1.1-1.monetdb.noarch.rpm
# Update & upgrade
RUN yum update -y && \
    yum upgrade -y

# Install supervisor
RUN yum install -y supervisor

# Install MonetDB
RUN yum install -y MonetDB-SQL-server5 MonetDB-client
# Install the MonetDB/GEOM module
RUN yum install -y MonetDB-geom-MonetDB5
# Install MonetDB/R (R is installed as a dependency)
RUN yum install -y MonetDB-R

# Clean up
RUN yum -y clean all

#######################################################
# Setup supervisord
#######################################################
# Create a log dir for the supervisor
RUN mkdir -p /var/log/supervisor
# Copy the config
COPY supervisord.ini /etc/supervisord.d/supervisord.ini

#######################################################
# Setup MonetDB
#######################################################
# Setup using the monetdb user
USER monetdb
# Start the dbfarm, create a new database, enable R integration and release it
RUN monetdbd start /var/monetdb5/dbfarm && \
    monetdb create db && \
    monetdb set embedr=true db && \
    monetdb start db && \
    monetdb release db && \
    monetdb stop db

#######################################################
# Helper scripts
#######################################################
COPY set-monetdb-password.sh /home/monetdb/set-monetdb-password.sh
# Switch back to root for the rest
USER root
RUN chmod +x /home/monetdb/set-monetdb-password.sh

#######################################################
# Expose ports
#######################################################
EXPOSE 50000

#######################################################
# Startup scripts
#######################################################
CMD ["/usr/bin/supervisord", "-n"]
