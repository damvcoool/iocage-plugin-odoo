#!/bin/sh
#
# TrueNAS plugin – first-time install of Odoo 18
#

set -e        # Stop on first error
umask 022

### 0.  Tweak these if you like
DB_USER="odoouser"
DB_NAME="odoodb"
DB_HOST="localhost"
DB_PORT="5432"
WEB_DB_MANAGER=false          # Hide the “Database Manager” screen
ODOO_ADDONS="/usr/local/lib/python3.11/site-packages/odoo/addons"

### 1.  Enable services so they start on boot
sysrc -q postgresql_enable=YES
sysrc -q odoo_enable=YES
sysrc -q odoo_database="${DB_NAME}"
sysrc -q odoo_datadir="/var/db/odoo"

chmod 777 /tmp                # Odoo writes temp files here at install

### 2.  Bootstrap PostgreSQL
service postgresql initdb
sleep 5
service postgresql start
sleep 5

# Generate strong random passwords
export LC_ALL=C
DB_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
ADMIN_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

# Save for the admin’s reference
printf '%s\n' "$DB_NAME"       > /root/dbname
printf '%s\n' "$DB_USER"       > /root/dbuser
printf '%s\n' "$DB_PASS"       > /root/dbpassword
printf '%s\n' "$ADMIN_PASS"    > /root/adminpassword

# Create DB role & database
su - postgres -c "createuser ${DB_USER} -SRD" || true
su - postgres -c "psql -c \"ALTER USER ${DB_USER} WITH PASSWORD '${DB_PASS}';\""
su - postgres -c "createdb -O ${DB_USER} ${DB_NAME}" || true

### 3.  Write /usr/local/etc/odoo/odoo.conf
ODOO_CONF="/usr/local/etc/odoo/odoo.conf"
[ -f "$ODOO_CONF" ] && mv "$ODOO_CONF" "${ODOO_CONF}.orig"

cat > "$ODOO_CONF" <<EOF
[options]
admin_passwd = $ADMIN_PASS
db_host      = $DB_HOST
db_port      = $DB_PORT
db_user      = $DB_USER
db_password  = $DB_PASS
list_db      = $WEB_DB_MANAGER
addons_path  = $ODOO_ADDONS
xmlrpc_port  = 8069
logfile      = /var/log/odoo.log
EOF

# Fix issue with werkzeug 3.1.3, and installing werkzeug 2.x
pip uninstall werkzeug -y
pip install "werkzeug<3.0"

touch /var/log/odoo.log
chmod 644 /var/log/odoo.log

### 4.  FIRST-RUN INITIALISATION
# FreeBSD’s rc.d script exposes “initdb” which runs Odoo with “-i all”
# and creates the initial metadata tables before daemonising.
service odoo initdb

### 5.  Human-readable cheat-sheet
cat > /root/PLUGIN_INFO <<EOF
====  Odoo TrueNAS Plugin  =======================================

Admin password    : $ADMIN_PASS
Database name     : $DB_NAME
Database user     : $DB_USER
Database password : $DB_PASS

Web login URL     : http://$(cat /etc/hosts | awk '/^::1/ {next} {print $1; exit}') :8069
Default UI login  : user 'admin' – set a password at first login.

The Odoo rc.d script supports:  start | stop | restart | status | initdb
==================================================================
EOF

echo ">>> Odoo installation complete."
