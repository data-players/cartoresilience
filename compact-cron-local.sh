#!/bin/bash

# Add /usr/local/bin directory where docker-compose is installed
#PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin

# check if the path is ok
cd cartoresilience

# Stop all containers including Fuseki
/usr/local/bin/docker-compose -f docker-compose-local.yaml down

# Launch compact service
/usr/local/bin/docker-compose -f docker-compose-local.yaml up -d fuseki_compact

# Restart 
/usr/local/bin/docker-compose -f docker-compose-local.yaml up -d

echo "[INFO] Cron job compact finished at" $(date)