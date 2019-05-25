output "webserverip" {
  value = "${azurerm_public_ip.mypublicip.ip_address}"
}
