#!/bin/sh

PRODUCT_NAME="Stemcells for PCF" \
PRODUCT_VERSION="3586.27" \
DOWNLOAD_REGEX="google" \
  ${HOME}/pcf/scripts/import-product.sh

PRODUCT_NAME="RabbitMQ for PCF" \
PRODUCT_VERSION="1.13.12" \
DOWNLOAD_REGEX="RabbitMQ for PCF$" \
  ${HOME}/pcf/scripts/import-product.sh
IMPORTED_NAME="p-rabbitmq" IMPORTED_VERSION="1.13.12" ./scripts/stage-product.sh
IMPORTED_NAME="p-rabbitmq" IMPORTED_VERSION="1.13.12" ./scripts/configure-product.sh
