#!/bin/bash

SECRETS_DIR=secrets
CONF_FILE="${SECRETS_DIR}/pcf.conf"
PROJECT_ID=`gcloud config get-value core/project`
SERVICE_ACCOUNT_FILE="${SECRETS_DIR}/gcp-credentials.json"

mkdir -p "${SECRETS_DIR}"

if [ ! -f "${SERVICE_ACCOUNT_FILE}" ]; then
    echo "Initializing Google service account"
    gcloud iam service-accounts create terraform --display-name terraform || exit 1
    gcloud projects add-iam-policy-binding $(gcloud config get-value core/project) \
        --member "serviceAccount:terraform@$(gcloud config get-value core/project).iam.gserviceaccount.com" \
        --role 'roles/owner' || exit 1
    gcloud iam service-accounts keys create ${SERVICE_ACCOUNT_FILE} \
        --iam-account "terraform@$(gcloud config get-value core/project).iam.gserviceaccount.com" || exit 1
fi

echo "Initializing configuration"
cat > ${CONF_FILE} <<-EOF
GCP_PROJECT_ID="${PROJECT_ID}"
GCP_SERVICE_ACCOUNT="${SERVICE_ACCOUNT_FILE}"

PCF_PIVNET_UAA_TOKEN="CHANGE_ME_PCF_PIVNET_UAA_TOKEN"   # see https://network.pivotal.io/users/dashboard/edit-profile
PCF_DOMAIN_NAME="CHANGE_ME_DOMAIN_NAME"                 # e.g. cfapps.io
PCF_SUBDOMAIN_NAME="CHANGE_ME_SUBDOMAIN_NAME"           # e.g. dev
PCF_OPSMAN_ADMIN_PASSWD="CHANGE_ME_OPSMAN_ADMIN_PASSWD" # e.g. must be 20 characters long
PCF_REGION="CHANGE_ME_REGION"                           # e.g. europe-west1
PCF_AZ_1="CHANGE_ME_AZ_1"                               # e.g. europe-west1-b
PCF_AZ_2="CHANGE_ME_AZ_2"                               # e.g. europe-west1-c
PCF_AZ_3="CHANGE_ME_AZ_3"                               # e.g. europe-west1-d

OPSMAN_VERSION="2.4.1"
PAS_VERSION="2.4.1"
PKS_VERSION="1.2.4"
EOF

echo "Please update the configuration file: ${CONF_FILE}"
echo "Then, you can bootstrap the jumpbox on GCP by running:"
echo "  $ ./install.sh"
