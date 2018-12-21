#!/bin/bash

source "${HOME}/secrets/pcf.conf"

echo "Installing Pivotal Cloud Foundry Operations Manager ${OPSMAN_VERSION}"
cd ${HOME}/pcf/pivotal-cf-terraforming-gcp-*/terraforming-pas/
ln -sf ../../terraform.tfvars .

echo "Running Terraform"
terraform init || exit 1
terraform apply --auto-approve || exit 1

echo "Enabling internal authentication"
${HOME}/pcf/scripts/configure-authentication.sh || exit 1

echo "Configuring BOSH Director"
IMPORTED_VERSION=${OPSMAN_VERSION} TARGET_PLATFORM=pas ${HOME}/pcf/scripts/configure-director-gcp.sh || exit 1

echo "Downloading PAS ${PAS_VERSION}"
PRODUCT_NAME="Pivotal Application Service (formerly Elastic Runtime)" \
PRODUCT_VERSION="${PAS_VERSION}" \
DOWNLOAD_REGEX="Small Footprint PAS" \
  ${HOME}/pcf/scripts/download-product.sh || exit 1

echo "Importing PAS ${PAS_VERSION}"
PRODUCT_NAME="Pivotal Application Service (formerly Elastic Runtime)" \
PRODUCT_VERSION="${PAS_VERSION}" \
DOWNLOAD_REGEX="Small Footprint PAS" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

echo "Staging PAS ${PAS_VERSION}"
IMPORTED_NAME="cf" IMPORTED_VERSION="${PAS_VERSION}" ${HOME}/pcf/scripts/stage-product.sh || exit 1

echo "Configuring PAS ${PAS_VERSION}"
IMPORTED_NAME="cf" IMPORTED_VERSION="${PAS_VERSION}" ${HOME}/pcf/scripts/configure-product.sh || exit 1

echo "Installing PAS ${PAS_VERSION}"
${HOME}/pcf/scripts/apply-changes.sh || exit 1
