# Pivotal Cloud Foundry, the easy way 👍

This project provides a set of scripts for deploying
[PCF](https://pivotal.io/platform) (including PAS & PKS)
on different public Cloud providers. GCP is only supported at the moment,
Azure is coming soon.

Disclaimer: **Do not use this project to install PCF in production!**

This project is all about automating everything:
 - terraforming a jumpbox from scratch, containing any required tools
   such as [OM](https://github.com/pivotal-cf/om),
   [pivnet](https://github.com/pivotal-cf/pivnet-cli),
   [jq](https://stedolan.github.io/jq/) ;
 - downloading bits from [Pivotal Network](https://network.pivotal.io), such as
   [PKS](https://pivotal.io/platform/pivotal-container-service),
   [PAS](https://pivotal.io/platform/pivotal-application-service)
   and many tiles like
   [RabbitMQ](https://network.pivotal.io/products/p-rabbitmq/) or
   [MySQL](https://network.pivotal.io/products/pivotal-mysql/) ;
 - terraforming infrastructure for PCF, using official scripts from Pivotal ;
 - configuring and installing PCF with tiles ;
 - cleaning up your installation when you're done.

All these steps are implemented using scripts. You should be able to deploy
PCF without having to enter configuration properties or dealing with UI.

## Target audience

The target audience for this project is someone planning to deploy PCF on a
public Cloud provider. This process is usually done by a Pivotal Platform
Architect working with a customer.

## Prerequisites

You need to install the following tools on your workstation:
 - [Terraform](https://www.terraform.io/)
 - [Google Cloud SDK](https://cloud.google.com/sdk/)
   (if you deploy PCF to GCP)

This project has been tested on Mac OS X using
[Bash](https://www.gnu.org/software/bash/).
Feel free to reach me if you find a bug, or if you managed to run these 
scripts on a different platform.

You need to register a domain name for your PCF installation.
This domain name must include a subdomain used by PCF.
For example: `dev.myfancydomain.com`. 

Domain and subdomains must be properly configured depending on your public
Cloud provider. If you're using GCP, your domain name must target all Google nameservers.

For example:
```text
dev IN NS ns-cloud-a1.googledomains.com.
dev IN NS ns-cloud-a2.googledomains.com.
dev IN NS ns-cloud-a3.googledomains.com.
dev IN NS ns-cloud-a4.googledomains.com.
dev IN NS ns-cloud-b1.googledomains.com.
...
dev IN NS ns-cloud-e1.googledomains.com.
dev IN NS ns-cloud-e2.googledomains.com.
dev IN NS ns-cloud-e3.googledomains.com.
dev IN NS ns-cloud-e4.googledomains.com.
```

In order to deploy PCF, you need to provide your Pivotal Network API
token, used to download PCF bits. Your API token is available from your
[Pivotal Network profile](https://network.pivotal.io/users/dashboard/edit-profile).

And you obviously need an active Cloud provider account to deploy PCF.

## Installation steps

You're about to deploy PCF to a public Cloud provider. The installation 
process is made of three phases:
 1. first you provide a configuration file, where you define few parameters
   such as platform domain name, passwords, etc.
 2. then you create a jumpbox in the Cloud, a special VM used to install PCF
   without using your workstation
 3. finally, you start deploying PCF from the jumpbox, and you choose which
   tiles to include

Before deploying PCF, you need to choose which component you want to install:
PAS or PKS. You cannot install both components in the same Cloud project at
the moment.

Using the jumpbox you'll be able to install PAS or PKS on your Cloud project.

### Deploy the jumpbox to GCP

Make sure Google Cloud SDK is properly configured:
```bash
$ gcloud auth login
```

Select your GCP project:
```bash
$ gcloud config set project <project_id>
```

From the `bootstrap/gcp` directory, initialize your configuration file:
```bash
$ cd bootstrap/gcp
$ ./init.sh
Please update the configuration file: secrets/pcf.conf
Then, you can bootstrap the jumpbox on GCP by running:
  $ ./install.sh
```

A configuration file named `secrets/pcf.conf` has been created.
Edit this file according to your setup:
```json
GCP_PROJECT_ID="XXX"
GCP_SERVICE_ACCOUNT="secrets/gcp-credentials.json"

PCF_PIVNET_UAA_TOKEN="XXX"
PCF_DOMAIN_NAME="myfancydomain.com"
PCF_SUBDOMAIN_NAME="dev"
PCF_OPSMAN_ADMIN_PASSWD="20characterspassword"
PCF_REGION="europe-west1"
PCF_AZ_1="europe-west1-b"
PCF_AZ_2="europe-west1-c"
PCF_AZ_3="europe-west1-d"

OPSMAN_VERSION="2.4.1"
PAS_VERSION="2.4.1"
PKS_VERSION="1.3.0"
```

Note that a Google service account named `terraform` has been added to your
GCP project: a service account key file has been created in `secrets/gcp-credentials.json`.

When you're done setting up your configuration file, you can bootstrap
the jumpbox:
```bash
$ ./install.sh
```

A new VM named `jbox-pcf` is created by Terraform scripts. This VM
contains all the tools required for deploying PCF.

You can connect to your jumpbox using GCP:
```bash
$ gcloud compute ssh ubuntu@jbox-pcf --zone <zone>
```

### Deploy the jumpbox to Azure

Coming soon 😕

### Install PAS

Connect to the jumpbox.
From the `pcf` directory, initialize your PCF installation:
```bash
$ cd pcf
$ ./init.sh
```

Terraform scripts are downloaded from Pivotal Network: these scripts are
used to create the PCF infrastructure: networks, load balancers, public IP, etc.

You are now ready to install PAS:
```bash
$ ./install-pas.sh
```

Using this script, the following tasks are executed:
 - Cloud infrastructure is initialized using Terraform scripts
 - OpsManager VM is created, using a VM image downloaded from Pivotal Network
 - BOSH is installed
 - a default configuration is applied for PAS
 - PAS is installed

OpsManager is available at `http://pcf.subdomain.domain.com`.
Use login `admin` and your password to sign in.

#### Import PAS tiles

The following tiles can be easily imported to your PCF installation:
 - MySQL for PCF: run `import-mysql.sh`
 - RabbitMQ for PCF: run `import-rabbitmq.sh`
 - Redis for PCF: run `import-redis.sh`
 - Spring Cloud Services: run `import-scs.sh`
 - PCF Healthwatch: run `import-healthwatch.sh`
 - PCF Metrics: run `import-metrics.sh`

A default configuration is applied for each tile.

After importing a tile to OpsManager, you need to apply changes to run the
installation. Use OpsManager UI to select the tile to install or use this
script to install all imported tiles:
```bash
$ scripts/apply-changes.sh
```

### Install PKS

**Please remember you cannot install both PAS and PKS in the same Cloud
project! Destroy previous installation before installing a new one.**

Connect to the jumpbox.
From the `pcf` directory, initialize your PCF installation:
```bash
$ cd pcf
$ ./init.sh
```

Terraform scripts are downloaded from Pivotal Network: these scripts are
used to create the PCF infrastructure: networks, load balancers, public IP, etc.

You are now ready to install PKS:
```bash
$ ./install-pks.sh
```

Using this script, the following tasks are executed:
 - Cloud infrastructure is initialized using Terraform scripts
 - OpsManager VM is created, using a VM image downloaded from Pivotal Network
 - BOSH is installed
 - a default configuration is applied for PKS
 - PKS is installed

OpsManager is available at `http://pcf.subdomain.domain.com`.
Use login `admin` and your password to sign in.

Read the [Pivotal PKS documentation](https://docs.pivotal.io/runtimes/pks/1-3/configure-api.html)
to setup PKS access.
Then, you should be able to create Kubernetes clusters.

### Configure BOSH

Get BOSH Director generated credentials from OpsManager.

Connect to OpsManager VM using SSH.

Run this command to connect to your BOSH installation:
```bash
$ bosh alias-env pcf -e 10.0.0.10 --ca-cert /var/tempest/workspaces/default/root_ca_certificate
```

From this point, you can use BOSH commands.

## Clean up

Connect to the jumpbox.
From the `pcf` directory, run this command to delete PCF:
```bash
$ cd pcf
$ om -k delete-installation
```

Destroy PAS infrastructure using Terraform:
```bash
$ cd pivotal-cf-terraforming-*/terraforming-pas
$ terraform destroy
```

Same command for PKS infrastructure:
```bash
$ cd pivotal-cf-terraforming-*/terraforming-pks
$ terraform destroy
```

Finally, you may want to destroy the jumpbox.
Run this command on your workstation, from the `bootstrap/<iaas>` directory:
```bash
$ terraform destroy
```

## Source

Many thanks to [Alan McGinlay](https://github.com/amcginlay), a great
Pivotal instructor who created most of the scripts included in this project
in [ops-manager-automation](https://github.com/amcginlay/ops-manager-automation).

## Contribute

Contributions are always welcome!

Feel free to open issues & send PR.

## License

Copyright &copy; 2019 [Pivotal Software, Inc](https://pivotal.io).

This project is licensed under the [Apache Software License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
