#!/bin/bash

PRODUCT_NAME="Spring Cloud Services for PCF" \
PRODUCT_VERSION="2.0.5" \
DOWNLOAD_REGEX="Spring Cloud Services Product Installer" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="p-spring-cloud-services" IMPORTED_VERSION="2.0.5" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="p-spring-cloud-services" IMPORTED_VERSION="2.0.5" ${HOME}/pcf/scripts/configure-product.sh || exit 1
