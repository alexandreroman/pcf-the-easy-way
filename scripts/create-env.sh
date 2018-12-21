#!/bin/bash

CONF_FILE="${HOME}/secrets/pcf.conf"
source "${CONF_FILE}"

ENV_FILE="${HOME}/.env"
/bin/cp "${CONF_FILE}" "${ENV_FILE}" 
cat >> "${ENV_FILE}" <<-EOF

PCF_OPSMAN_FQDN=pcf.\${PCF_SUBDOMAIN_NAME}.\${PCF_DOMAIN_NAME}
export OM_TARGET=\${PCF_OPSMAN_FQDN}
export OM_USERNAME=admin
export OM_PASSWORD=\${PCF_OPSMAN_ADMIN_PASSWD}
export OM_DECRYPTION_PASSPHRASE=\${PCF_OPSMAN_ADMIN_PASSWD}
EOF

echo "source ~/.env" >> ${HOME}/.bashrc
