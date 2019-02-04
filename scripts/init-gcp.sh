#!/bin/bash

source "${HOME}/.env"

sudo apt-get update && sudo apt-get install -y google-cloud-sdk

gcloud auth activate-service-account --key-file=${GCP_SERVICE_ACCOUNT} || exit 1
gcloud config set core/project ${GCP_PROJECT_ID} || exit 1

gcloud services enable compute.googleapis.com || exit 1
gcloud services enable iam.googleapis.com || exit 1
gcloud services enable cloudresourcemanager.googleapis.com || exit 1
gcloud services enable dns.googleapis.com || exit 1
gcloud services enable sqladmin.googleapis.com || exit 1

cd ${HOME}/pcf && ln -sf scripts/init-infra-gcp.sh init.sh
cd ${HOME}/pcf && ln -sf scripts/install-pks-gcp.sh install-pks.sh
cd ${HOME}/pcf && ln -sf scripts/install-pas-gcp.sh install-pas.sh
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
