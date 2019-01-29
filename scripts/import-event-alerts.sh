#!/bin/sh

PRODUCT_NAME="Pivotal Cloud Foundry Event Alerts" \
PRODUCT_VERSION="1.2.6" \
DOWNLOAD_REGEX="PCF Event Alerts" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="p-event-alerts" IMPORTED_VERSION="1.2.6" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="p-event-alerts" IMPORTED_VERSION="1.2.6" ${HOME}/pcf/scripts/configure-product.sh || exit 1
