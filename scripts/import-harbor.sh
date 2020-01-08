#!/bin/sh

PRODUCT_NAME="VMware Harbor Container Registry for Pivotal Platform" \
PRODUCT_VERSION="1.10.0" \
DOWNLOAD_REGEX="^VMware Harbor" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
PRODUCT_VERSION="1.10.0" \
BUILD_VERSION="build.18" \
IMPORTED_NAME="harbor-container-registry" IMPORTED_VERSION="${PRODUCT_VERSION}-${BUILD_VERSION}" ${HOME}/pcf/scripts/stage-product.sh || exit 1
PRODUCT_VERSION="1.10.0" \
BUILD_VERSION="build.18" \
IMPORTED_NAME="harbor-container-registry" IMPORTED_VERSION="${PRODUCT_VERSION}-${BUILD_VERSION}" ${HOME}/pcf/scripts/configure-product.sh || exit 1

echo ""
echo "After installing Harbor, you need to manually setup a load balancer"
echo "redirecting traffic on port 443 to the Harbor VM."
echo "Don't forget to add a firewall rule to allow incoming"
echo "traffic on port 443 on this VM."
