resource "azurerm_virtual_network" "myvmnetwork" {
  name = "myvnet"
  address_space = ["192.168.0.0/16"]
  location = "west us"
  resource_group_name = "${azurerm_resource_group.myvm.name}" 
}

resource "azurerm_subnet" "mysubnet" {

  name = "mysubnet"
  resource_group_name = "${azurerm_resource_group.myvm.name}"
  virtual_network_name = "${azurerm_virtual_network.myvmnetwork.name}"
  address_prefix = "192.168.0.0/24"  
}


resource "azurerm_public_ip" "mypublicip" {
    name                         = "myPublicIP"
    location                     = "${azurerm_resource_group.myvm.location}"
    resource_group_name          = "${azurerm_resource_group.myvm.name}"
    allocation_method            = "Dynamic"

}

resource "azurerm_network_security_group" "mynsg" {
    name                = "mynsg"
    location            = "${azurerm_resource_group.myvm.location}"
    resource_group_name = "${azurerm_resource_group.myvm.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges     = ["22","8080","80"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "mynic" {
    name                = "myNIC"
    location            = "${azurerm_resource_group.myvm.location}"
    resource_group_name = "${azurerm_resource_group.myvm.name}"
    network_security_group_id = "${azurerm_network_security_group.mynsg.id}"

    ip_configuration {
        name                          = "myprivateip"
        subnet_id                     = "${azurerm_subnet.mysubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.mypublicip.id}"
    }
}