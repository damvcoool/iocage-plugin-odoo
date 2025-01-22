## HOW-TO Install

```shell
BRANCH=master
JSON=/tmp/odoo.json

fetch -o "$JSON" "https://raw.githubusercontent.com/damvcoool/iocage-plugin-index/${BRANCH}/odoo.json"
iocage fetch -P "$JSON" --branch "$BRANCH" -n Odoo
```

# iocage-plugin-odoo

iocage plugin for Odoo.
