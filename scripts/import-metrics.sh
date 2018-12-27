#!/bin/sh

PRODUCT_NAME="Pivotal Cloud Foundry Metrics" \
PRODUCT_VERSION="1.5.2" \
DOWNLOAD_REGEX="PCF Metrics" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="apmPostgres" IMPORTED_VERSION="1.5.2-build.4" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="apmPostgres" IMPORTED_VERSION="1.5.2-build.4" ${HOME}/pcf/scripts/configure-product.sh || exit 1
