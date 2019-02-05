#!/bin/bash

set -u # explode if any env vars are not set

function printline() {
  echo && printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - && echo $1
}

SCRIPTDIR=$(cd $(dirname "$0") && pwd -P)
VARS=${HOME}/.env

if ! which om > /dev/null; then
  echo "error: scripts require 'om' to be installed (https://github.com/pivotal-cf/om/releases)"
  exit 1
fi

if ! which pivnet > /dev/null; then
  echo "error: scripts require 'pivnet' to be installed (https://github.com/pivotal-cf/pivnet-cli/releases)"
  exit 1
fi

if ! which jq > /dev/null; then
  echo "error: scripts require 'jq' to be installed (https://github.com/stedolan/jq/releases)"
  exit 1
fi

while read LINE; do
  [[ ! -z ${LINE} ]] && eval export ${LINE}
done < ${VARS}

export API="https://network.pivotal.io/api/v2"

# calculated vars
export PCF_DOMAIN=${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}
if [ -f "${HOME}/pcf/${PCF_DOMAIN}.key" ]; then
  export PCF_DOMAIN_KEY=$(cat "${HOME}/pcf/${PCF_DOMAIN}.key")
fi
if [ -f "${HOME}/pcf/${PCF_DOMAIN}.crt" ]; then
  export PCF_DOMAIN_CRT=$(cat "${HOME}/pcf/${PCF_DOMAIN}.crt")
fi
if [ -f "${HOME}/pcf/${PCF_DOMAIN}.ca.crt" ]; then
  export PCF_DOMAIN_CA=$(cat "${HOME}/pcf/${PCF_DOMAIN}.ca.crt")
fi
if [ -f "${HOME}/pcf/opsman-ssh.pub" ]; then
  export PCF_OPSMAN_SSH_PUB=$(cat "${HOME}/pcf/opsman-ssh.pub")
fi
if [ -f "${HOME}/pcf/opsman-ssh.key" ]; then
  export PCF_OPSMAN_SSH_KEY=$(cat "${HOME}/pcf/opsman-ssh.key")
fi

if [ -z "${TMPDIR:-}" ]; then 
  TMPDIR=/tmp
fi
