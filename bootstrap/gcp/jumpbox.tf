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
