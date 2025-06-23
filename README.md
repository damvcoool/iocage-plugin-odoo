# Odoo TrueNAS Plugin (iocage)

Unofficial [TrueNAS CORE](https://www.truenas.com/truenas-core/) plugin to install [Odoo 18](https://www.odoo.com/) — the all-in-one open source business suite — inside a FreeBSD jail using `iocage`.

> ⚠️ **Status**: Work in progress (WIP) — not yet production-hardened.

---

## 🚀 Features

- Installs **Odoo 18** from FreeBSD ports
- Configures **PostgreSQL 17** with a secure admin and database user
- Automatically generates `odoo.conf`
- Accessible via `http://<JAIL-IP>:8069`
- Compatible with **TrueNAS CORE 13.3-U1.2**

---

## 📦 Installation

Run the following commands on your TrueNAS CORE host:

```sh
BRANCH=master
JSON=/tmp/odoo.json

fetch -o "$JSON" "https://raw.githubusercontent.com/damvcoool/iocage-plugin-index/${BRANCH}/odoo.json"
iocage fetch -P "$JSON" --branch "$BRANCH" -n Odoo
```
