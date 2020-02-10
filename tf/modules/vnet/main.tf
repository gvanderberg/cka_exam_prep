resource "azurerm_virtual_network" "this" {
  name                = "azvnet-dev-zn-k8s"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = "azsnet-dev-zn-lan"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefix       = "10.0.2.0/24"
}
