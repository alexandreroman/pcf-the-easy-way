#!/bin/bash

source "${HOME}/secrets/pcf.conf"

echo "Installing Pivotal Cloud Foundry Operations Manager ${OPSMAN_VERSION}"
cd ${HOME}/pcf/pivotal-cf-terraforming-gcp-*/terraforming-pks/
ln -sf ../../terraform.tfvars .

echo "Initializing Terraform"
terraform init || exit 1

echo "Running Terraform"
terraform apply --auto-approve || exit 1

echo "Waiting for OpsManager to start"
sleep 90

echo "Enabling internal authentication"
${HOME}/pcf/scripts/configure-authentication.sh || exit 1

echo "Configuring BOSH Director"
IMPORTED_VERSION=${OPSMAN_VERSION} TARGET_PLATFORM=pks ${HOME}/pcf/scripts/configure-director-gcp.sh || exit 1

echo "Installing BOSH Director"
${HOME}/pcf/scripts/apply-changes.sh || exit 1

echo "Importing Ubuntu Stemcells"

PRODUCT_NAME="Stemcells for PCF (Ubuntu Xenial)" \
PRODUCT_VERSION="97.43" \
DOWNLOAD_REGEX="Google Cloud Platform" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

PRODUCT_NAME="Stemcells for PCF (Ubuntu Xenial)" \
PRODUCT_VERSION="170.15" \
DOWNLOAD_REGEX="Google Cloud Platform" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

PRODUCT_NAME="Pivotal Stemcells (Ubuntu Xenial)" \
PRODUCT_VERSION="456.77" \
DOWNLOAD_REGEX="Google Cloud Platform" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

echo "Importing PKS ${PKS_VERSION}"
PRODUCT_NAME="Pivotal Container Service (PKS)" \
PRODUCT_VERSION="${PKS_VERSION}" \
DOWNLOAD_REGEX="Pivotal Container Service" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1

STAGED_VERSION=`om --skip-ssl-validation available-products -f json | jq -r '.[] | select(.name="pivotal-container-service") | .version'`

echo "Staging PKS ${PKS_VERSION}"
IMPORTED_NAME="pivotal-container-service" IMPORTED_VERSION="${STAGED_VERSION}" ${HOME}/pcf/scripts/stage-product.sh || exit 1

echo "Configuring PKS ${PKS_VERSION}"
IMPORTED_NAME="pivotal-container-service" IMPORTED_VERSION="${STAGED_VERSION}" ${HOME}/pcf/scripts/configure-product.sh || exit 1

echo "Installing PKS ${PKS_VERSION}"
${HOME}/pcf/scripts/apply-changes.sh || exit 1
