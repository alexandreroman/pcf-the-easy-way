#!/bin/bash

source "${HOME}/.env"

echo "Initializing Pivotal Cloud Foundry Operations Manager ${OPSMAN_VERSION}"

PRODUCT_NAME="Pivotal Cloud Foundry Operations Manager" \
DOWNLOAD_REGEX="Pivotal Cloud Foundry Ops Manager YAML for Azure" \
PRODUCT_VERSION=${OPSMAN_VERSION} \
  ${HOME}/pcf/scripts/download-product.sh || exit 1

OPSMAN_IMAGE=$(bosh interpolate ./downloads/ops-manager_${OPSMAN_VERSION}_*/OpsManager*onAzure.yml --path /west_us)

PRODUCT_NAME="Pivotal Application Service (formerly Elastic Runtime)" \
DOWNLOAD_REGEX="Azure Terraform Templates" \
PRODUCT_VERSION=${PAS_VERSION} \
  ${HOME}/pcf/scripts/download-product.sh || exit 1
unzip -o ${HOME}/pcf/downloads/elastic-runtime_${PAS_VERSION}_*/terraforming-azure-*.zip -d .

echo "Generating self-signed certificate"
${HOME}/pcf/scripts/mk-ssl-cert-key.sh || exit 1

echo "Generating Terraform configuration"

cat > terraform.tfvars <<-EOF
subscription_id       = "${PCF_SUBSCRIPTION_ID}"
tenant_id             = "${PCF_TENANT_ID}"
client_id             = "${PCF_APP_ID}"
client_secret         = "${PCF_APP_SECRET}"

env_name              = "${PCF_SUBDOMAIN_NAME}"
env_short_name        = "${PCF_SHORT_NAME}"
location              = "${PCF_LOCATION}"
ops_manager_image_uri = "${OPSMAN_IMAGE}"
dns_suffix            = "${PCF_DOMAIN_NAME}"
vm_admin_username     = "${OM_PASSWORD}"
isolation_segment     = false
EOF

echo ""
echo "You are now ready to install PCF on Azure."
echo ""
echo "If you want to install Pivotal Application Service, run:"
echo "  $ ./install-pas.sh"
echo ""
echo "If you want to install Pivotal Container Service, run:"
echo "  $ ./install-pks.sh"
