#!/bin/bash

PRODUCT_NAME="Spring Cloud Services for PCF" \
PRODUCT_VERSION="2.0.5" \
DOWNLOAD_REGEX="Spring Cloud Services Product Installer" \
  ./scripts/import-product.sh
IMPORTED_NAME="p-spring-cloud-services" IMPORTED_VERSION="2.0.5" ./scripts/stage-product.sh
IMPORTED_NAME="p-spring-cloud-services" IMPORTED_VERSION="2.0.5" ./scripts/configure-product.sh
