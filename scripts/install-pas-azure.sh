#!/bin/bash

source "${HOME}/secrets/pcf.conf"

echo "Installing Pivotal Cloud Foundry Operations Manager ${OPSMAN_VERSION}"
cd ${HOME}/pcf/pivotal-cf-terraforming-azure-*/terraforming-pas/
ln -sf ../../terraform.tfvars .

echo "Initializing Terraform"
terraform init || exit 1

echo "Running Terraform"
terraform apply --auto-approve || exit 1

terraform output ops_manager_ssh_public_key >> "${HOME}/pcf/opsman-ssh.pub"
terraform output ops_manager_ssh_private_key >> "${HOME}/pcf/opsman-ssh.key"

echo "Waiting for OpsManager to start"
sleep 90

echo "Enabling internal authentication"
${HOME}/pcf/scripts/configure-authentication.sh || exit 1

echo "Configuring BOSH Director"
IMPORTED_VERSION=${OPSMAN_VERSION} TARGET_PLATFORM=pas ${HOME}/pcf/scripts/configure-director-azure.sh || exit 1

echo "Installing BOSH Director"
${HOME}/pcf/scripts/apply-changes.sh || exit 1

echo "Importing Ubuntu Stemcells"

PRODUCT_NAME="Stemcells for PCF (Ubuntu Xenial)" \
PRODUCT_VERSION="170.15" \
DOWNLOAD_REGEX="Azure" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

PRODUCT_NAME="Stemcells for PCF (Ubuntu Xenial)" \
PRODUCT_VERSION="97.43" \
DOWNLOAD_REGEX="Azure" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

PRODUCT_NAME="Stemcells for PCF" \
PRODUCT_VERSION="3586.60" \
DOWNLOAD_REGEX="Ubuntu Trusty Stemcell for Azure" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

echo "Importing PAS ${PAS_VERSION}"
PRODUCT_NAME="Pivotal Application Service (formerly Elastic Runtime)" \
PRODUCT_VERSION="${PAS_VERSION}" \
DOWNLOAD_REGEX="Small Footprint PAS" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

STAGED_VERSION=`om --skip-ssl-validation available-products -f json | jq -r '.[] | select(.name="cf") | .version'`

echo "Staging PAS ${PAS_VERSION}"
IMPORTED_NAME="cf" IMPORTED_VERSION="${PAS_VERSION}" ${HOME}/pcf/scripts/stage-product.sh || exit 1

echo "Configuring PAS ${PAS_VERSION}"
PLATFORM="azure" IMPORTED_NAME="cf" IMPORTED_VERSION="${PAS_VERSION}" ${HOME}/pcf/scripts/configure-product.sh || exit 1

echo "Installing PAS ${PAS_VERSION}"
${HOME}/pcf/scripts/apply-changes.sh || exit 1
