# Wrapper-level output.tf
output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.azure_firewall.resource_group_name
}

output "resource_group_location" {
  description = "The location of the resource group."
  value       = module.azure_firewall.resource_group_location
}

output "vnet_id" {
  description = "The ID of the virtual network."
  value       = module.azure_firewall.vnet_id
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = module.azure_firewall.subnet_ids
}

output "management_subnet_id" {
  description = "The ID of the management subnet."
  value       = module.azure_firewall.management_subnet_id
}

output "public_ip_id" {
  description = "The ID of the public IP."
  value       = module.azure_firewall.public_ip_id
}

output "management_public_ip_id" {
  description = "The ID of the management public IP."
  value       = module.azure_firewall.management_public_ip_id
}

output "firewall_id" {
  description = "The ID of the Azure Firewall."
  value       = module.azure_firewall.firewall_id
}

output "firewall_policy_id" {
  description = "The ID of the Azure Firewall Policy."
  value       = module.azure_firewall.firewall_policy_id
}

output "firewall_policy_rule_collection_group_id" {
  description = "The ID of the Azure Firewall Policy Rule Collection Group."
  value       = module.azure_firewall.firewall_policy_rule_collection_group_id
}
