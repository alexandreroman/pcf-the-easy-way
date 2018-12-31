#!/bin/sh

PRODUCT_NAME="RabbitMQ for PCF" \
PRODUCT_VERSION="1.13.12" \
DOWNLOAD_REGEX="RabbitMQ for PCF$" \
  ${HOME}/pcf/scripts/import-product.sh || exit 1
IMPORTED_NAME="p-rabbitmq" IMPORTED_VERSION="1.13.12" ${HOME}/pcf/scripts/stage-product.sh || exit 1
IMPORTED_NAME="p-rabbitmq" IMPORTED_VERSION="1.13.12" ${HOME}/pcf/scripts/configure-product.sh || exit 1
