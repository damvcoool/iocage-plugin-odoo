#!/bin/sh

sysrc postgresql_enable=YES 2>/dev/null

sysrc odoo_enable=YES 2>/dev/null

sysrc odoo_database="odoodb" 2>/dev/null
sysrc odoo_datadir="/var/db/odoo" 2>/dev/null

chmod 777 /tmp
# Start the service
service postgresql initdb 2>/dev/null
sleep 5
service postgresql start 2>/dev/null
sleep 5

USER="odoouser"
DB="odoodb"

# Save the config values
echo "$DB" > /root/dbname
echo "$USER" > /root/dbuser
export LC_ALL=C
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/dbpassword
PASS=`cat /root/dbpassword`

# create db user
psql -d template1 -U postgres -c "CREATE USER ${USER} CREATEDB SUPERUSER;" 2>/dev/null
# Set a password on the postgres account
psql -d template1 -U postgres -c "ALTER USER ${USER} IDENTIFIED WITH caching_sha2_password BY '${PASS}';" 2>/dev/null

service odoo initdb

service odoo start

# Save database information
echo "Host: localhost or 127.0.0.1" > /root/PLUGIN_INFO
echo "Database Type: PostgresSQL" >> /root/PLUGIN_INFO
echo "Database Name: $DB" >> /root/PLUGIN_INFO
echo "Database User: $USER" >> /root/PLUGIN_INFO
echo "Database Password: $PASS" >> /root/PLUGIN_INFO

echo "Done"
