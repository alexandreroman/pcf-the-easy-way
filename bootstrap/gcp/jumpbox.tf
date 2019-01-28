resource "google_compute_instance" "default" {
    name         = "jbox-pcf"
    machine_type = "f1-micro"
    zone         = "${var.PCF_AZ_1}"
    tags         = [ "jbox-pcf" ]

    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-1804-lts"
            size  = 200
        }
    }

    network_interface {
        network = "default"
        access_config {}
    }

    provisioner "remote-exec" {
        inline = [
        "mkdir /home/ubuntu/pcf",
        ]

        connection {
                type = "ssh"
                user = "ubuntu"
                private_key = "${file("~/.ssh/google_compute_engine")}"
        }
    }

    provisioner "file" {
        source      = "../../scripts"
        destination = "/home/ubuntu/pcf/scripts/"

        connection {
                type = "ssh"
                user = "ubuntu"
                private_key = "${file("~/.ssh/google_compute_engine")}"
        }
    }

    provisioner "file" {
        source      = "../../config"
        destination = "/home/ubuntu/pcf/config/"

        connection {
                type = "ssh"
                user = "ubuntu"
                private_key = "${file("~/.ssh/google_compute_engine")}"
        }
    }

    provisioner "file" {
        source      = "secrets"
        destination = "/home/ubuntu/secrets/"

        connection {
                type = "ssh"
                user = "ubuntu"
                private_key = "${file("~/.ssh/google_compute_engine")}"
        }
    }

    provisioner "remote-exec" {
        inline = [
        "chmod +x /home/ubuntu/pcf/scripts/*.sh",
        "/home/ubuntu/pcf/scripts/create-env.sh",
        "/home/ubuntu/pcf/scripts/init-gcp.sh",
        "/home/ubuntu/pcf/scripts/install-tools.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/init-infra-gcp.sh init.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/install-pks-gcp.sh install-pks.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/install-pas-gcp.sh install-pas.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-mysql.sh import-mysql.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-rabbitmq-gcp.sh import-rabbitmq.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-scs.sh import-scs.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-redis.sh import-redis.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-healthwatch.sh import-healthwatch.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-metrics.sh import-metrics.sh",
        "cd /home/ubuntu/pcf && ln -s scripts/import-harbor.sh import-harbor.sh",
        ]

        connection {
                type = "ssh"
                user = "ubuntu"
                private_key = "${file("~/.ssh/google_compute_engine")}"
        }
    }
}

resource "google_compute_firewall" "default" {
    name = "jbox-pcf-ssh"
    network = "default"
    
    allow {
        protocol = "tcp"
        ports = [ "22" ]
    }

    target_tags = [ "jbox-pcf" ]
}
