resource "random_integer" "this" {
  count = var.virtual_machine_count
  min   = 1000
  max   = 5000
}

resource "azurerm_public_ip" "this" {
  count               = var.virtual_machine_count
  name                = format("%s-pip-%s", format("%s%s", var.virtual_machine_name, count.index + 1), random_integer.this[count.index].result)
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_network_interface" "this" {
  count               = var.virtual_machine_count
  name                = format("%s-nic-%s", format("%s%s", var.virtual_machine_name, count.index + 1), random_integer.this[count.index].result)
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = format("ipconfig%s", random_integer.this[count.index].result)
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.this[count.index].id
  }

  tags = var.tags
}

# resource "azurerm_network_interface_backend_address_pool_association" "this" {
#   count                   = var.backend_address_pool_id == "" ? 0 : var.virtual_machine_count
#   network_interface_id    = azurerm_network_interface.this[count.index].id
#   ip_configuration_name   = "testconfiguration1"
#   backend_address_pool_id = var.backend_address_pool_id
# }

resource "azurerm_virtual_machine" "this" {
  count                            = var.virtual_machine_count
  name                             = format("%s%s", var.virtual_machine_name, count.index + 1)
  location                         = var.resource_group_location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [azurerm_network_interface.this[count.index].id]
  vm_size                          = var.virtual_machine_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = format("%s_os_disk_1_%s", format("%s%s", var.virtual_machine_name, count.index + 1), random_integer.this[count.index].result)
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = format("%s%s", var.computer_name, count.index + 1)
    admin_username = "azuresupport"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "this" {
  count                = var.virtual_machine_count
  name                 = "KubeInit"
  resource_group_name  = var.resource_group_name
  location             = var.resource_group_location
  virtual_machine_name = azurerm_virtual_machine.this[count.index].name
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.2"

  settings = <<SETTINGS
  {
  "fileUris": ["https://raw.githubusercontent.com/gvanderberg/cka_exam_prep/master/scripts/setup.sh"],
  "commandToExecute": "./setup.sh",
  "timestamp" : "12"
  }
SETTINGS

  tags = var.tags
}
