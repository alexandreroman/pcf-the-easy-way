#!/bin/bash

SECRETS_DIR=secrets
CONF_FILE="${SECRETS_DIR}/pcf.conf"
if [ ! -f "${CONF_FILE}" ]; then
    echo "Missing configuration: please run ./init.sh"
    exit 1
fi
source "${CONF_FILE}"

GCP_SERVICE_ACCOUNT_KEY=`cat "${GCP_SERVICE_ACCOUNT}"`
TF_VARS_FILE="terraform.tfvars"

echo "Creating Terraform configuration"
/bin/cp -f "${CONF_FILE}" "${TF_VARS_FILE}"
cat >> "${TF_VARS_FILE}" <<-EOF

PCF_CONF="${CONF_FILE}"
GCP_SERVICE_ACCOUNT_KEY=<<SERVICE_ACCOUNT_KEY
${GCP_SERVICE_ACCOUNT_KEY}
SERVICE_ACCOUNT_KEY
PCF_OPSMAN_FQDN="pcf.${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}"
EOF

echo "Initializing Terraform"
terraform init || exit 1

echo "Running Terraform"
terraform apply -auto-approve || exit 1

echo ""
echo "You successfully bootstrapped the jumpbox on GCP."
echo ""
echo "You can now initialize the installation process from the jumbox:"
echo "  $ gcloud compute ssh ubuntu@jbox-pcf --zone ${PCF_AZ_1}"
echo "  $ cd /home/ubuntu/pcf"
echo "  $ ./init.sh"
