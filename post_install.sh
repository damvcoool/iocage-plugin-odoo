#!/bin/sh

# Defining config settings
DB_USER="odoouser"
DB="odoodb"
DB_HOST="localhost"
DB_PORT="5432"

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


# Save the config values
echo "$DB" > /root/dbname
echo "$USER" > /root/dbuser
export LC_ALL=C
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/dbpassword
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/adimpassword
DB_PASS=`cat /root/dbpassword`
PASS=`cat /root/adimpassword`

# create db user
psql -d template1 -U postgres -c "CREATE USER ${USER} CREATEDB SUPERUSER;" 2>/dev/null
# Set a password on the postgres account
psql -d template1 -U postgres -c "ALTER USER ${USER} IDENTIFIED WITH caching_sha2_password BY '${PASS}';" 2>/dev/null

#Setting up odoo.conf
echo "[options]" > /root/odoo.conf
echo "admin_passwd = $PASS" >> /root/odoo.conf
echo "db_host = $DB_HOST" >> /root/odoo.conf
echo "db_port = $DB_PORT" >> /root/odoo.conf
echo "db_user =  $DB_USER" >> /root/odoo.conf
echo "db_password = $DB_PASS" >> /root/odoo.conf
echo "addons_path = /usr/local/lib/pyt" >> /root/odoo.conf

service odoo initdb

service odoo start

# Save database information
echo "Admin Password: $PASS" >> /root/PLUGIN_INFO
echo "Database Type: PostgresSQL" >> /root/PLUGIN_INFO
echo "Database Name: $DB" >> /root/PLUGIN_INFO
echo "Database User: $DB_USER" >> /root/PLUGIN_INFO
echo "Database Password: $DB_PASS" >> /root/PLUGIN_INFO

echo "Done"
