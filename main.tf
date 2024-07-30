module "resource-group" {
  for_each                = var.create_resource_group ? { rg1 = var.resource_group_name } : {}
  source                  = "OT-terraform-azure-modules/resource-group/azure"
  version                 = "0.0.1"
  resource_group_name     = each.value
  resource_group_location = var.resource_group_location
  lock_level_value        = var.lock_level_value
  tag_map = merge(
    {
      "Name" = each.value
    },
    var.tags,
  )
}

module "virtual-network" {
  count   = var.vnet_name == "" ? 0 : length(var.vnet_name)
  source  = "OT-terraform-azure-modules/virtual-network/azure"
  version = "0.0.2"
  #"../../../modules/network/vnet"
  depends_on                  = [module.resource-group]
  resource_group_name         = var.resource_group_name
  resource_group_location     = var.resource_group_location
  address_space               = element(var.address_space, count.index)
  vnet_name                   = element(var.vnet_name, count.index)
  dns_servers                 = var.dns_servers
  create_ddos_protection_plan = element(var.create_ddos_protection_plan, count.index)
  tag_map = merge(
    {
      "Name" = element(var.vnet_name, count.index)
    },
    var.tags,
  )
}

module "subnet" {
  count   = var.subnet_name == "" ? 0 : length(var.subnet_name)
  source  = "OT-terraform-azure-modules/subnet/azure"
  version = "0.0.2"
  #"../../../modules/network/subnet"
  depends_on              = [module.virtual-network]
  resource_group_name     = var.resource_group_name
  vnet_name               = element(var.vnet_name, count.index)
  subnet_name             = element(var.subnet_name, count.index)
  subnet_address_prefixes = element(var.subnet_address_prefixes, count.index)
  service_endpoints       = var.service_endpoints
}

module "management_subnet" {
  count                   = (var.forced_tunneling || var.forced_tunneling == "Basic") ? 1 : 0
  source                  = "OT-terraform-azure-modules/subnet/azure"
  version                 = "0.0.2"
  depends_on              = [module.virtual-network]
  resource_group_name     = var.resource_group_name
  vnet_name               = element(var.vnet_name, count.index)
  subnet_name             = element(var.management_subnet_name, count.index)
  subnet_address_prefixes = element(var.management_subnet_address_prefixes, count.index)
  service_endpoints       = var.management_subnet_service_endpoints
}

module "public_ip" {
  source              = "github.com/OT-terraform-azure-modules/terraform-azure-public-ip//?ref=v-0.0.3"
  public_ip_name      = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  tags                = var.tags
}


module "management_public_ip" {
  source              = "github.com/OT-terraform-azure-modules/terraform-azure-public-ip//?ref=v-0.0.3"
  count               = (var.forced_tunneling || var.forced_tunneling == "Basic") ? 1 : 0
  public_ip_name      = var.management_public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  tags                = var.tags
}

resource "azurerm_firewall" "default" {
  name                = var.firewall_configuration.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = var.firewall_configuration.sku_name
  sku_tier            = var.firewall_configuration.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.default.id
  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = module.subnet[0].subnet_id[0]
    public_ip_address_id = module.public_ip.public_ip_id[0]
  }
  dynamic "management_ip_configuration" {
    for_each = (var.firewall_configuration.sku_tier == "Basic" || var.forced_tunneling) ? [1] : []
    content {
      name                 = "managementConfiguration"
      subnet_id            = module.management_subnet[0].subnet_id[0]
      public_ip_address_id = module.management_public_ip[0].public_ip_id[0]
    }
  }
}


resource "azurerm_firewall_policy" "default" {
  name                     = var.firewall_policy_configuration.name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  sku                      = var.firewall_policy_configuration.sku
  threat_intelligence_mode = var.firewall_policy_configuration.threat_intelligence_mode
}


resource "azurerm_firewall_policy_rule_collection_group" "default" {
  name               = var.firewall_policy_rule_collection_group.name
  firewall_policy_id = azurerm_firewall_policy.default.id
  priority           = var.firewall_policy_rule_collection_group.priority

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action
      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name = rule.value.name
          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collections
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action
      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = var.nat_rule_collections
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action
      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = module.public_ip.public_ip_address[0]
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}

