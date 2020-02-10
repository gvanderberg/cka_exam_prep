resource "azurerm_public_ip" "this" {
  name                = "azlb-dev-zn-k8s-api-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "this" {
  name                = "azlb-dev-zn-k8s-api"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "this" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  name                = "BackEndAddressPool"
}