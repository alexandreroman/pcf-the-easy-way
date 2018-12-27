#!/bin/sh

PRODUCT_NAME="Pivotal Cloud Foundry Healthwatch" \
PRODUCT_VERSION="1.4.4" \
DOWNLOAD_REGEX="PCF Healthwatch" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="p-healthwatch" IMPORTED_VERSION="1.4.4-build.1" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="p-healthwatch" IMPORTED_VERSION="1.4.4-build.1" ${HOME}/pcf/scripts/configure-product.sh || exit 1
