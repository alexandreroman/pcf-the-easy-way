#!/bin/sh

PRODUCT_NAME="Pivotal Cloud Foundry Metrics" \
PRODUCT_VERSION="1.6.0" \
DOWNLOAD_REGEX="PCF Metrics" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="apmPostgres" IMPORTED_VERSION="1.6.0-build.41" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="apmPostgres" IMPORTED_VERSION="1.6.0-build.41" ${HOME}/pcf/scripts/configure-product.sh || exit 1
