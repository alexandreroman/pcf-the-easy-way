resource "azurerm_resource_group" "jumpbox" {
  name     = "pcf-jumpbox-resources"
  location = "${var.AZURE_LOCATION}"
}

resource "azurerm_public_ip" "jumpbox" {
    name                         = "jumpbox-public-ip"
    location                     = "${azurerm_resource_group.jumpbox.location}"
    resource_group_name          = "${azurerm_resource_group.jumpbox.name}"
    allocation_method            = "Static"
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "jumpbox-nic"
  location            = "${azurerm_resource_group.jumpbox.location}"
  resource_group_name = "${azurerm_resource_group.jumpbox.name}"

  ip_configuration {
    name                          = "jumpbox-ip-configuration"
    subnet_id                     = "${azurerm_subnet.jumpbox.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}"
  }
}

resource "azurerm_virtual_network" "jumpbox" {
  name                = "jumpbox-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.jumpbox.location}"
  resource_group_name = "${azurerm_resource_group.jumpbox.name}"
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "jumpbox-subnet"
  resource_group_name  = "${azurerm_resource_group.jumpbox.name}"
  virtual_network_name = "${azurerm_virtual_network.jumpbox.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_virtual_machine" "jumpbox" {
    name                  = "jumpbox"
    location              = "${azurerm_resource_group.jumpbox.location}"
    resource_group_name   = "${azurerm_resource_group.jumpbox.name}"
    network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "jumpbox-os-disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = "jumpbox"
        admin_username = "ubuntu"
        admin_password = "${random_string.jumpbox-password.result}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    provisioner "remote-exec" {
        inline = [
        "mkdir /home/ubuntu/pcf",
        ]

        connection {
                type = "ssh"
                user = "ubuntu"
                password = "${random_string.jumpbox-password.result}"
        }
    }

    provisioner "file" {
        source      = "../../scripts"
        destination = "/home/ubuntu/pcf/scripts/"

        connection {
                type = "ssh"
                user = "ubuntu"
                password = "${random_string.jumpbox-password.result}"
        }
    }

    provisioner "file" {
        source      = "../../config"
        destination = "/home/ubuntu/pcf/config/"

        connection {
                type = "ssh"
                user = "ubuntu"
                password = "${random_string.jumpbox-password.result}"
        }
    }

    provisioner "file" {
        source      = "secrets"
        destination = "/home/ubuntu/secrets/"

        connection {
                type = "ssh"
                user = "ubuntu"
                password = "${random_string.jumpbox-password.result}"
        }
    }

    provisioner "remote-exec" {
        inline = [
        "chmod +x /home/ubuntu/pcf/scripts/*.sh",
        "/home/ubuntu/pcf/scripts/create-env.sh",
        "/home/ubuntu/pcf/scripts/init-azure.sh",
        "/home/ubuntu/pcf/scripts/install-tools.sh",
        ]

        connection {
                type = "ssh"
                user = "ubuntu"
                password = "${random_string.jumpbox-password.result}"
        }
    }
}

resource "random_string" "jumpbox-password" {
  length  = 16
  special = false
}

output "jumpbox-password" {
  value = "${random_string.jumpbox-password.result}"
}

output "jumpbox-public-ip" {
    value = "${azurerm_public_ip.jumpbox.ip_address}"
}
