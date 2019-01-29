#!/bin/sh

PRODUCT_NAME="Redis for PCF" \
PRODUCT_VERSION="2.0.0" \
DOWNLOAD_REGEX="Redis for PCF$" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="p-redis" IMPORTED_VERSION="2.0.0" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="p-redis" IMPORTED_VERSION="2.0.0" ${HOME}/pcf/scripts/configure-product.sh || exit 1
