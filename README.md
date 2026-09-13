# iocage-plugin-odoo

Unofficial [FreeCORE](https://github.com/freecore-project/) (TrueNAS CORE replacement) plugin to install [Odoo 18](https://www.odoo.com/).

> **Status**: Personal plugin — not affiliated with or supported by Nextcloud GmbH or iXsystems.

---

## Installation

Run the following commands on your FreeCORE host:

```sh
BRANCH=master
JSON=/tmp/odoo.json

fetch -o "$JSON" "https://raw.githubusercontent.com/damvcoool/iocage-plugin-index/${BRANCH}/odoo.json"

iocage fetch -P "$JSON" -n Odoo
```

---

## Post-Installation

After installation completes, you can access:

- **Web Interface**: `http://[jail-ip]:8069`
- **Default Login**: Username `admin` (password set on first login)

### Credentials Location

All credentials are stored securely in the jail's `/root` directory:

- `/root/PLUGIN_INFO` — Complete setup information
- `/root/adminpassword` — Odoo admin password
- `/root/dbname` — PostgreSQL database name
- `/root/dbuser` — PostgreSQL username
- `/root/dbpassword` — PostgreSQL password

Access these files via:

```sh
iocage console Odoo
cat /root/PLUGIN_INFO
```

---

## Configuration

### Odoo Configuration File

Main configuration: `/usr/local/etc/odoo/odoo.conf`

### Service Management

```sh
# Start/Stop/Restart Odoo
service odoo start
service odoo stop
service odoo restart
service odoo status

# Reinitialize database (WARNING: destructive)
service odoo initdb
```

---

## Security Best Practices

1. **Change Default Passwords**: Immediately change the auto-generated passwords after installation
2. **Firewall Configuration**: Limit access to port 8069 to trusted networks only
3. **HTTPS Setup**: Consider setting up a reverse proxy (nginx, caddy) with SSL/TLS
4. **Regular Updates**: Keep the jail and packages updated
5. **Backups**: Regularly backup PostgreSQL database and Odoo data directory

### Setting Up HTTPS (Recommended)

For production use, configure a reverse proxy with SSL certificates:

```sh
# Example using nginx in another jail or on the host
# Forward HTTPS traffic to http://[odoo-jail-ip]:8069
```

---

## Database Backup

To backup your Odoo database:

```sh
iocage console Odoo
su - postgres
pg_dump odoodb > /root/odoodb_backup_$(date +%Y%m%d).sql
```

---

## Troubleshooting

### Check Service Status

```sh
iocage console Odoo
service odoo status
service postgresql status
```

### View Logs

```sh
# Odoo logs
tail -f /var/log/odoo.log

# PostgreSQL logs
tail -f /var/db/postgres/data15/log/postgresql-*.log
```

### Common Issues

**Odoo won't start:**

- Check if PostgreSQL is running: `service postgresql status`
- Verify database exists: `su - postgres -c "psql -l"`
- Check log file for errors: `tail -100 /var/log/odoo.log`

**Cannot access web interface:**

- Verify jail IP: `iocage get ip4_addr Odoo`
- Check if port 8069 is listening: `sockstat -l | grep 8069`
- Ensure firewall rules allow access

**Werkzeug version issues:**

- The install script automatically installs werkzeug <3.0 for compatibility

---

## Version Information

- **Odoo Version**: 18.0
- **FreeBSD**: Compatible with FreeCORE (FreeBSD-based)
- **PostgreSQL**: Version 15+
- **Python**: 3.11

---

## Contributing

This is a community project. Issues and pull requests are welcome!

## License

This plugin configuration is provided as-is. Odoo itself is licensed under LGPL v3.

## Disclaimer

This is an unofficial plugin not affiliated with or supported by iXsystems or Odoo S.A. Use at your own risk.
