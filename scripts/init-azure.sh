#!/bin/bash

source "${HOME}/.env"

sudo apt-get update && sudo apt-get install -y apt-transport-https lsb-release software-properties-common dirmngr
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF

sudo apt-get update && sudo apt-get install azure-cli

az login --username "${PCF_APP_ID}" --password "${PCF_APP_SECRET}" --service-principal --tenant "${PCF_TENANT_ID}" > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "Invalid credentials"
    exit 1
fi

cd ${HOME}/pcf && ln -sf scripts/init-infra-azure.sh init.sh
cd ${HOME}/pcf && ln -sf scripts/install-pks-azure.sh install-pks.sh
cd ${HOME}/pcf && ln -sf scripts/install-pas-azure.sh install-pas.sh
cd ${HOME}/pcf && ln -sf scripts/import-mysql.sh import-mysql.sh
cd ${HOME}/pcf && ln -sf scripts/import-rabbitmq.sh import-rabbitmq.sh
cd ${HOME}/pcf && ln -sf scripts/import-scs.sh import-scs.sh
cd ${HOME}/pcf && ln -sf scripts/import-redis.sh import-redis.sh
cd ${HOME}/pcf && ln -sf scripts/import-healthwatch.sh import-healthwatch.sh
cd ${HOME}/pcf && ln -sf scripts/import-metrics.sh import-metrics.sh
cd ${HOME}/pcf && ln -sf scripts/import-metrics-forwarder.sh import-metrics-forwarder.sh
cd ${HOME}/pcf && ln -sf scripts/import-event-alerts.sh import-event-alerts.sh
cd ${HOME}/pcf && ln -sf scripts/import-sso.sh import-sso.sh
cd ${HOME}/pcf && ln -sf scripts/import-harbor.sh import-harbor.sh
