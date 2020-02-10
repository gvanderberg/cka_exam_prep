output "network_interface_ids" {
  value = azurerm_network_interface.this.*.id
}
