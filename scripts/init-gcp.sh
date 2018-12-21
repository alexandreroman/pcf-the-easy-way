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
