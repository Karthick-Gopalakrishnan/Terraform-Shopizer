resource "azurerm_virtual_machine" "web" {

  name = "web",
  location = "${azurerm_resource_group.myvm.location}"
  resource_group_name = "${azurerm_resource_group.myvm.name}"
  vm_size ="Standard_B1s"
  network_interface_ids = ["${azurerm_network_interface.mynic.id}"]
  

  storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvm"
        admin_username = "azureuser"
        admin_password = "${var.password}"
    }

 os_profile_linux_config {
    disable_password_authentication = false
    }

  connection {
  type = "ssh"
  user = "azureuser"
  password = "${var.password}"

  }

 provisioner "file"{
 source = "script.sh"
 destination = "/home/azureuser/script.sh"
  } 

provisioner "file"{
 source = "myinvent"
 destination = "/home/azureuser/myinvent"
  }

provisioner "file"{
 source = "check.yml"
 destination = "/home/azureuser/check.yml"
}

provisioner "file"{
 source = "tomcat.yml"
 destination = "/home/azureuser/tomcat.yml"
}

provisioner "remote-exec"{

  inline = [
    "sh script.sh"
    ]
}
provisioner "remote-exec" {
  inline = ["ansible-playbook -c local check.yml",
            "ansible-playbook -c local tomcat.yml"
            ]
}

provisioner "file"{
 source = "myshop.war"
 destination = "/home/azureuser/myshop.war"  
}
provisioner "remote-exec"{
  inline = ["sudo cp myshop.war /opt/tomcat/webapps/"]
}

}




