#!/bin/bash

SECRETS_DIR=secrets
CONF_FILE="${SECRETS_DIR}/pcf.conf"
if [ ! -f "${CONF_FILE}" ]; then
    echo "Missing configuration: please run ./init.sh"
    exit 1
fi
source "${CONF_FILE}"

echo "Checking Azure Service Principal..."
az login --username "${AZURE_APP_ID}" --password "${AZURE_APP_SECRET}" --service-principal --tenant "${AZURE_TENANT_ID}" > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "Invalid credentials"
    exit 1
fi
SERVICE_PRINCIPAL_TYPE=`az account list | jq -r '.[0].user.type'`
if [ "${SERVICE_PRINCIPAL_TYPE}" != "servicePrincipal" ]; then
    echo "Invalid Azure Service Principal type: ${SERVICE_PRINCIPAL_TYPE}"
    exit 1
fi
echo "Azure Service Principal authenticated"

TF_VARS_FILE="terraform.tfvars"

echo "Creating Terraform configuration"
/bin/cp -f "${CONF_FILE}" "${TF_VARS_FILE}"

echo "Initializing Terraform"
terraform init || exit 1

echo "Running Terraform"
terraform apply -auto-approve || exit 1

JUMPBOX_IP=`terraform output jumpbox-public-ip`
JUMPBOX_PASSWORD=`terraform output jumpbox-password`

echo ""
echo "You successfully bootstrapped the jumpbox on Azure."
echo ""
echo "You can now initialize the installation process from the jumbox:"
echo "  $ ssh ubuntu@${JUMPBOX_IP}"
echo "    <password: ${JUMPBOX_PASSWORD}>"
echo "  $ cd /home/ubuntu/pcf"
echo "  $ ./init.sh"
