#!/bin/bash

# Add /usr/local/bin directory where docker-compose is installed
#PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin

# check if the path is ok
cd deploy-archipelago-classic

# Stop all containers including Fuseki
/usr/local/bin/docker-compose -f docker-compose-prod.yaml down

# Launch compact service
/usr/local/bin/docker-compose -f docker-compose-prod.yaml up -d fuseki_compact

# Restart 
/usr/local/bin/docker-compose -f docker-compose-prod.yaml up -d

echo "[INFO] Cron job compact finished at" $(date)