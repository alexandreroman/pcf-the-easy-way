#!/bin/sh

PRODUCT_NAME="MySQL for PCF" \
PRODUCT_VERSION="2.4.2" \
DOWNLOAD_REGEX="^MySQL for PCF" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="pivotal-mysql" IMPORTED_VERSION="2.4.2-build.9" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="pivotal-mysql" IMPORTED_VERSION="2.4.2-build.9" ${HOME}/pcf/scripts/configure-product.sh || exit 1
