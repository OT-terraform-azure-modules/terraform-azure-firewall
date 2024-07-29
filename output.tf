output "resource_group_name" {
  description = "The name of the resource group."
  value       = var.resource_group_name
}

output "resource_group_location" {
  description = "The location of the resource group."
  value       = var.resource_group_location
}

output "vnet_id" {
  description = "The ID of the virtual network."
  value       = length(module.virtual-network) > 0 ? module.virtual-network[0].vnet_id : null
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = length(module.subnet) > 0 ? module.subnet[*].subnet_id : []
}

output "management_subnet_id" {
  description = "The ID of the management subnet."
  value       = length(module.management_subnet) > 0 ? module.management_subnet[0].subnet_id : null
}

output "public_ip_id" {
  description = "The ID of the public IP."
  value       = length(module.public_ip) > 0 ? module.public_ip.public_ip_id : null
}

output "management_public_ip_id" {
  description = "The ID of the management public IP."
  value       = length(module.management_public_ip) > 0 ? module.management_public_ip[0].public_ip_id : null
}

output "firewall_id" {
  description = "The ID of the Azure Firewall."
  value       = azurerm_firewall.default.id
}

output "firewall_policy_id" {
  description = "The ID of the Azure Firewall Policy."
  value       = azurerm_firewall_policy.default.id
}

output "firewall_policy_rule_collection_group_id" {
  description = "The ID of the Azure Firewall Policy Rule Collection Group."
  value       = azurerm_firewall_policy_rule_collection_group.default.id
}
