#!/bin/sh

PRODUCT_NAME="Metrics Forwarder for PCF" \
PRODUCT_VERSION="1.11.4" \
DOWNLOAD_REGEX="Metrics Forwarder for PCF" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="p-metrics-forwarder" IMPORTED_VERSION="1.11.4" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="p-metrics-forwarder" IMPORTED_VERSION="1.11.4" ${HOME}/pcf/scripts/configure-product.sh || exit 1
