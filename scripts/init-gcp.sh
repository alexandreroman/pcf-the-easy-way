#!/bin/bash

source "${HOME}/.env"
GCLOUD="/snap/bin/gcloud"

${GCLOUD} auth activate-service-account --key-file=${GCP_SERVICE_ACCOUNT}
${GCLOUD} config set core/project ${GCP_PROJECT_ID}

${GCLOUD} services enable compute.googleapis.com && \
${GCLOUD} services enable iam.googleapis.com && \
${GCLOUD} services enable cloudresourcemanager.googleapis.com && \
${GCLOUD} services enable dns.googleapis.com && \
${GCLOUD} services enable sqladmin.googleapis.com
