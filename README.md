# Odoo TrueNAS Plugin (iocage)

Unofficial [TrueNAS CORE](https://www.truenas.com/truenas-core/) plugin to install [Odoo 18](https://www.odoo.com/).

> ⚠️ **Status**: Work in progress (WIP) — not yet production-hardened.

---

## 📦 Installation

Run the following commands on your TrueNAS CORE host:

```sh
BRANCH=master
JSON=/tmp/odoo.json

fetch -o "$JSON" "https://raw.githubusercontent.com/damvcoool/iocage-plugin-index/${BRANCH}/odoo.json"
iocage fetch -P "$JSON" --branch "$BRANCH" -n Odoo
```
