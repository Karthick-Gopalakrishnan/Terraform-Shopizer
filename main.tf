provider "azurerm" {

subscription_id = "${var.subcriptionid}"
client_id = "${var.clientid}"
client_secret = "${var.clientsecret}"
tenant_id = "${var.tenantid}"
}

resource "azurerm_resource_group" "myvm" {
  name     = "vmresource"
  location = "West US"
    tags = {
      environment = "demo"
    }
  }
