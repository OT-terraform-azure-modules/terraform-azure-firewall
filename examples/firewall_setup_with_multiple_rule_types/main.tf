module "azure_firewall" {
  source = "../../"

  # Resurce configuration
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  lock_level_value        = var.lock_level_value

  # Network configuration
  vnet_name                           = var.vnet_name
  address_space                       = var.address_space
  vnet_location                       = var.vnet_location
  dns_servers                         = var.dns_servers
  create_ddos_protection_plan         = var.create_ddos_protection_plan
  subnet_name                         = var.subnet_name
  subnet_address_prefixes             = var.subnet_address_prefixes
  service_endpoints                   = var.service_endpoints
  forced_tunneling                    = var.forced_tunneling
  management_subnet_name              = var.management_subnet_name
  management_subnet_address_prefixes  = var.management_subnet_address_prefixes
  management_subnet_service_endpoints = var.management_subnet_service_endpoints

  # Public IP
  public_ip_name              = var.public_ip_name
  management_public_ip_name   = var.management_public_ip_name
  public_ip_allocation_method = var.public_ip_allocation_method
  public_ip_sku               = var.public_ip_sku

  # Firewall Configuration 
  firewall_configuration                = var.firewall_configuration
  ip_configuration_name                 = var.ip_configuration_name
  firewall_policy_configuration         = var.firewall_policy_configuration
  firewall_policy_rule_collection_group = var.firewall_policy_rule_collection_group
  application_rule_collections          = var.application_rule_collections
  network_rule_collections              = var.network_rule_collections
  nat_rule_collections                  = var.nat_rule_collections

  # Additional Configurations
  tags = var.tags

}