############################################################
# Dockerfile to build MonetDB container images
# Based on CentOS 7
############################################################

FROM milcom/centos7-systemd
MAINTAINER Dimitar Nedev, dimitar.nedev@monetdbsolutions.com

#############################################################
# Enables repos, update system, install packages and clean up
#############################################################
# Enable EPEL repo
RUN yum install -y epel-release
# Enable MonetDB repo
RUN yum install -y https://dev.monetdb.org/downloads/epel/MonetDB-release-epel-1.1-1.monetdb.noarch.rpm
# Update & upgrade
RUN yum update -y && \
    yum upgrade -y

# Install supervisor
RUN yum install -y supervisor

# Install MonetDB
RUN yum install -y MonetDB-SQL-server5 MonetDB-client
# Install the MonetDB/GEOM module
RUN yum install -y MonetDB-geom-MonetDB5
# Install MonetDB/R and R (as dependency)
RUN yum install -y MonetDB-R

# Clean up
RUN yum -y clean all

#######################################################
# Setup supervisord
#######################################################
# Create a log dir for the supervisor
RUN mkdir -p /var/log/supervisor
# Copy the config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#######################################################
# Setup MonetDB
#######################################################
# Create a new database
RUN mkdir -p /var/monetdb5/db
# Create a .monetdb file s.t. users of the container can more easily login (with the default credentials)
RUN echo -e "user=monetdb\npassword=monetdb" > .monetdb

#######################################################
# Expose ports
#######################################################
EXPOSE 50000

#######################################################
# Startup scripts
#######################################################
COPY start-monetdb.sh start-monetdb.sh
COPY set-monetdb-password.sh set-monetdb-password.sh
RUN chmod +x start-monetdb.sh && \
    chmod +x set-monetdb-password.sh
CMD ["/usr/bin/supervisord", "-n"]
