#!/bin/bash

source "${HOME}/secrets/pcf.conf"

echo "Initializing Pivotal Operations Manager ${OPSMAN_VERSION}"

PRODUCT_NAME="Pivotal Operations Manager" \
DOWNLOAD_REGEX="Pivotal Ops Manager YAML for GCP" \
PRODUCT_VERSION=${OPSMAN_VERSION} \
  ${HOME}/pcf/scripts/download-product.sh || exit 1

OPSMAN_IMAGE=$(bosh interpolate ./downloads/ops-manager_${OPSMAN_VERSION}_*/ops-manager-*.yml --path /us)

PRODUCT_NAME="Pivotal Application Service" \
DOWNLOAD_REGEX="GCP Terraform Templates" \
PRODUCT_VERSION=${PAS_VERSION} \
  ${HOME}/pcf/scripts/download-product.sh || exit 1
unzip -o ${HOME}/pcf/downloads/elastic-runtime_${PAS_VERSION}_*/terraforming-gcp-*.zip -d .

echo "Generating self-signed certificate"
${HOME}/pcf/scripts/mk-ssl-cert-key.sh || exit 1

echo "Generating Terraform configuration"

cat > terraform.tfvars <<-EOF
env_name            = "${PCF_SUBDOMAIN_NAME}"
project             = "$(gcloud config get-value core/project)"
region              = "${PCF_REGION}"
zones               = ["${PCF_AZ_2}", "${PCF_AZ_1}", "${PCF_AZ_3}"]
dns_suffix          = "${PCF_DOMAIN_NAME}"
opsman_image_url    = "https://storage.googleapis.com/${OPSMAN_IMAGE}"
create_gcs_buckets  = false
external_database   = 0
isolation_segment   = false
ssl_cert            = <<SSL_CERT
$(cat ${HOME}/pcf/${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}.crt)
SSL_CERT
ssl_private_key     = <<SSL_KEY
$(cat ${HOME}/pcf/${PCF_SUBDOMAIN_NAME}.${PCF_DOMAIN_NAME}.key)
SSL_KEY
service_account_key = <<SERVICE_ACCOUNT_KEY
$(cat ${HOME}/secrets/gcp-credentials.json)
SERVICE_ACCOUNT_KEY
EOF

echo ""
echo "You are now ready to install PCF on GCP."
echo ""
echo "If you want to install Pivotal Application Service, run:"
echo "  $ ./install-pas.sh"
echo ""
echo "If you want to install Pivotal Container Service, run:"
echo "  $ ./install-pks.sh"
