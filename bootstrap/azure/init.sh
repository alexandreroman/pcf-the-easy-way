#!/bin/bash

SECRETS_DIR=secrets
CONF_FILE="${SECRETS_DIR}/pcf.conf"

mkdir -p "${SECRETS_DIR}"

ACCOUNTS_COUNT=`az account list 2> /dev/null | jq length`
if [ "${ACCOUNTS_COUNT}" == "0" ]; then
    echo "Azure account with service principal not found."
    echo "Follow these instructions to login and create a Service Principal:"
    echo "  https://docs.pivotal.io/pivotalcf/2-4/om/azure/prepare-env-manual.html"
    exit 1
fi

echo "Initializing resources"

AZURE_TENANT_ID=`az account list | jq -r '.[0].tenantId'`
AZURE_SUBSCRIPTION_ID=`az account list | jq -r '.[0].id'`

az provider register --namespace Microsoft.Storage --wait
az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.Compute --wait

echo "Initializing configuration"
cat > ${CONF_FILE} <<-EOF
AZURE_TENANT_ID="${AZURE_TENANT_ID}"
AZURE_SUBSCRIPTION_ID="${AZURE_SUBSCRIPTION_ID}"

AZURE_APP_ID=""
AZURE_APP_SECRET=""

AZURE_LOCATION="France Central" # choose a location by running: $ az account list-locations

PCF_PLATFORM="azure"

PCF_PIVNET_UAA_TOKEN="CHANGE_ME_PCF_PIVNET_UAA_TOKEN"   # see https://network.pivotal.io/users/dashboard/edit-profile
PCF_DOMAIN_NAME="CHANGE_ME_DOMAIN_NAME"                 # e.g. cfapps.io
PCF_SUBDOMAIN_NAME="CHANGE_ME_SUBDOMAIN_NAME"           # e.g. dev
PCF_SHORT_NAME="CHANGE_ME"                              # unique value denoting this installation (up to 10 characters)
PCF_OPSMAN_ADMIN_PASSWD="CHANGE_ME_OPSMAN_ADMIN_PASSWD" # e.g. must be 20 characters long

OPSMAN_VERSION="2.4.3"
PAS_VERSION="2.4.2"
PKS_VERSION="1.3.1"
EOF

echo "Please update the configuration file: ${CONF_FILE}"
echo "Then, you can bootstrap the jumpbox on Azure by running:"
echo "  $ ./install.sh"
