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

echo "Done"
