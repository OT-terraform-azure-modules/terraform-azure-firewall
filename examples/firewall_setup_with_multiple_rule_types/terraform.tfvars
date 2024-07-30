# Resource Group
resource_group_name     = "demo"
resource_group_location = "Central India"
lock_level_value        = ""

# Vnet and Subnet 
vnet_name                           = ["demo-dev-vnet-001"]
address_space                       = [["10.0.0.0/16"]]
vnet_location                       = ["Central India"]
dns_servers                         = null
create_ddos_protection_plan         = [false]
subnet_name                         = [["AzureFirewallSubnet"]]
subnet_address_prefixes             = [["10.0.0.0/24"]]
service_endpoints                   = []
forced_tunneling                    = false
management_subnet_name              = [["AzureFirewallManagementSubnet"]]
management_subnet_address_prefixes  = [["10.0.2.0/24"]]
management_subnet_service_endpoints = []
# public ip

public_ip_name              = ["firewall-pubip"]
management_public_ip_name   = ["firewall-management-pubip"]
public_ip_allocation_method = "Static"
public_ip_sku               = "Standard"


# Firewall 
firewall_configuration = {
  name     = "testfirewall"
  sku_name = "AZFW_VNet"
  sku_tier = "Standard" # "Basic" "Premium"
}

ip_configuration_name = "configuration"

firewall_policy_configuration = {
  name                     = "example-policy"
  sku                      = "Basic" # "Standard"  "Premium" 
  threat_intelligence_mode = "Alert"
}

firewall_policy_rule_collection_group = {
  name     = "example-fwpolicy-rcg"
  priority = 500
}


application_rule_collections = [
  {
    name     = "app_rule_collection1"
    priority = 300
    action   = "Allow"
    rules = [
      {
        name = "app_rule_collection1_rule1"
        protocols = [
          { type = "Http", port = 80 },
          { type = "Https", port = 443 }
        ]
        source_addresses  = ["*"]
        destination_fqdns = ["*.google.com", "*.microsoft.com", "*.facebook.com", "facebook.com", "opstree.com"]
      }
    ]
  }
]


network_rule_collections = [
  {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Deny"
    rules = [
      {
        name                  = "network_rule_collection1_rule1"
        protocols             = ["TCP", "UDP"]
        source_addresses      = ["10.0.0.1"]
        destination_addresses = ["192.168.1.1", "192.168.1.2"]
        destination_ports     = ["80", "1000-2000"]
      }
    ]
  }
]


nat_rule_collections = [

  {
    name     = "nat_rule_collection2"
    priority = 100
    action   = "Dnat"
    rules = [{
      name               = "nat_rule_ssh"
      protocols          = ["TCP"]
      source_addresses   = ["*"]
      destination_ports  = ["22"]
      translated_address = "10.0.1.4"
      translated_port    = "22"
    }]
  }
]


tags = {
  provider = "terraform",
  owner    = "opstree"
}