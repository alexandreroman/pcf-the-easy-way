#!/bin/bash

PRODUCT_NAME="Single Sign-On for PCF" \
PRODUCT_VERSION="1.8.0" \
DOWNLOAD_REGEX="Pivotal_Single_Sign-On_Service" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="Pivotal_Single_Sign-On_Service" IMPORTED_VERSION="1.8.0" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="Pivotal_Single_Sign-On_Service" IMPORTED_VERSION="1.8.0" ${HOME}/pcf/scripts/configure-product.sh || exit 1
