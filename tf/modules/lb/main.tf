resource "azurerm_public_ip" "this" {
  name                = "kubernetes-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "this" {
  name                = "kubernetes-lb"
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
  name                = "kubernetes-lb-pool"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  name                = "kubernetes-apiserver-probe"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.this.id
  port                = 6443
  protocol            = "tcp"
}

resource "azurerm_lb_rule" "this" {
  name                           = "kubernetes-apiserver-rule"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.this.id
  backend_port                   = 6443
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  frontend_port                  = 6443
  probe_id                       = azurerm_lb_probe.this.id
  protocol                       = "tcp"
}
