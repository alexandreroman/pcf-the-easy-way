#!/bin/sh

PRODUCT_NAME="VMware Harbor Container Registry for PCF" \
PRODUCT_VERSION="1.7.1" \
DOWNLOAD_REGEX="^VMware Harbor" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="harbor-container-registry" IMPORTED_VERSION="1.7.1-build.3" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="harbor-container-registry" IMPORTED_VERSION="1.7.1-build.3" ${HOME}/pcf/scripts/configure-product.sh || exit 1

echo ""
echo "After installing Harbor, you need to manually setup a load balancer"
echo "redirecting traffic on port 443 to the Harbor VM."
echo "Don't forget to add a firewall rule to allow incoming"
echo "traffic on port 443 on this VM."
