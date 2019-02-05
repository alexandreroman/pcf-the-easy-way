#!/bin/bash

SCRIPTDIR=$(cd $(dirname "$0") && pwd -P)
source ${SCRIPTDIR}/shared.sh

[ -z ${IMPORTED_VERSION} ]
set $(echo ${IMPORTED_VERSION} | tr '.' ' ')
CONFIG_VERSION=${1}.${2}

TEMPLATES=${SCRIPTDIR}/../config/${IMPORTED_NAME}/${CONFIG_VERSION}

if [ "$PCF_PLATFORM" != "" ]; then
  NEW_TEMPLATES=$TEMPLATES/$PCF_PLATFORM
  if [ -f "$NEW_TEMPLATES" ]; then
    TEMPLATES=$NEW_TEMPLATES
  fi
fi

if [ -z ${PCF_DOMAIN_KEY+x} ]; then
	echo "PCF_DOMAIN_KEY is not set.  Did you forget to create a certificate? (see mk-ssl-cert-key.sh)"
	exit 1
fi

CONFIG="${TEMPLATES}/config.yml"
if [ "$PCF_PLATFORM" == "azure" ]; then
  if [ "$AZURE_SUBSCRIPTION_ID" != "" ]; then
    CONFIG=`mktemp`
    cat "${TEMPLATES}/config.yml" | sed "s/((AZ_1))/\"null\"/" | sed "s/((AZ_2))/\"null\"/" | sed "s/((AZ_3))/\"null\"/" > $CONFIG
  fi
fi

om --skip-ssl-validation \
  configure-product \
    --config "$CONFIG" \
    --vars-env PCF \
    --vars-env AZURE \
    --vars-env GCP

