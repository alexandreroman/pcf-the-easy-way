provider "google" {
    credentials = "${var.GCP_SERVICE_ACCOUNT_KEY}"
    project     = "${var.GCP_PROJECT_ID}"
    region      = "${var.PCF_REGION}"
}
