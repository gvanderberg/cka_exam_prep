variable "backend_address_pool_id" {
  description = "The ID of the Load Balancer Backend Address Pool which this Network Interface which should be connected to."
  type        = string
}

variable "computer_name" {
  description = "Specifies the name of the Virtual Machine."
  type        = string
}

variable "resource_group_location" {
  description = "The location where the resource group should be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "Reference to a subnet in which this NIC has been created."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map
}

variable "virtual_machine_count" {
  description = "Specifies the number of the Virtual Machines to create."
  type        = number
}

variable "virtual_machine_name" {
  description = "Specifies the name of the Virtual Machine."
  type        = string
}

variable "virtual_machine_size" {
  description = "Specifies the size of the Virtual Machine."
  type        = string
}
