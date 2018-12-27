#!/bin/sh

PRODUCT_NAME="MySQL for PCF" \
PRODUCT_VERSION="2.4.2" \
DOWNLOAD_REGEX="^MySQL for PCF" \
  ${HOME}/pcf/scripts/import-product.sh
IMPORTED_NAME="pivotal-mysql" IMPORTED_VERSION="2.4.2-build.9" ./scripts/stage-product.sh
IMPORTED_NAME="pivotal-mysql" IMPORTED_VERSION="2.4.2-build.9" ./scripts/configure-product.sh
