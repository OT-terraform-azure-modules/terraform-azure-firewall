/*------------------Resource group variable -----------*/
variable "create_resource_group" {
  description = "Whether to create the resource group."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Name of Resource Group"
}

variable "resource_group_location" {
  type        = string
  description = "(Required) Location where we want to implement code"
}

variable "lock_level_value" {
  type        = string
  default     = "CanNotDelete"
  description = "(Required) Specifies the Level to be used for this Lock. Possible values are `Empty (no lock)`, `CanNotDelete` and `ReadOnly`. Changing this forces a new resource to be created"
}

/*------------------ common tags -----------*/

variable "tags" {
  type        = map(string)
  description = "Map of Tags those we want to Add"
}


/*------------------Vnet variable -----------*/
variable "vnet_name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  type        = list(string)
}

variable "vnet_location" {
  type        = list(string)
  description = "names of the vnet's location"

}

variable "address_space" {
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
  type        = list(list(any))
}

variable "create_ddos_protection_plan" {
  description = "(Required) Create an ddos plan - Default is false"
  type        = list(bool)
  default     = [false]
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers"
  type        = list(string)
}

# /*------------------Subnet variable -----------*/
variable "subnet_name" {
  description = "The variable for subnet names"
  type        = list(list(string))
}

variable "subnet_address_prefixes" {
  description = "The CIDR block for the vnet"
  type        = list(list(string))
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet"
  type        = list(string)
}


variable "forced_tunneling" {
  description = "Flag to enable or disable forced tunneling"
  type        = bool
  default     = false
}

variable "management_subnet_name" {
  description = "The variable for subnet names"
  type        = list(list(string))
}

variable "management_subnet_address_prefixes" {
  description = "The CIDR block for the vnet"
  type        = list(list(string))
}

variable "management_subnet_service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet"
  type        = list(string)
}

/*------------------Public ip variable -----------*/

variable "public_ip_name" {
  type        = list(string)
  description = "(Required) Specifies the name of the Public IP resource"
}

variable "management_public_ip_name" {
  type        = list(string)
  description = "(Required) Specifies the name of the Public IP resource"
}

variable "public_ip_allocation_method" {
  type        = string
  description = "(Required) Defines the allocation method for this IP address.Possible values are Static or Dynamic"
  default     = "Dynamic"
}

variable "public_ip_sku" {
  type        = string
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Basic"
}

/*------------------Firewall Configuration -----------*/

variable "firewall_configuration" {
  description = "Configuration details for the Azure Firewall."
  type = object({
    name     = string
    sku_name = string
    sku_tier = string
  })
  default = {
    name     = "testfirewall"
    sku_name = "AZFW_VNet"
    sku_tier = "Standard"
  }
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration."
  type        = string
  default     = "configuration"
}


/*------------------Firewall Policy Configuration -----------*/

variable "firewall_policy_configuration" {
  description = "Configuration details for the Azure Firewall Policy."
  type = object({
    name                     = string
    sku                      = string
    threat_intelligence_mode = string
  })
  default = {
    name                     = "example-policy"
    sku                      = "Standard"
    threat_intelligence_mode = "Alert"
  }
}

variable "application_rule_collections" {
  description = "List of application rule collections for the Azure Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name = string
      protocols = list(object({
        type = string
        port = number
      }))
      source_addresses  = list(string)
      destination_fqdns = list(string)
    }))
  }))
  default = []
}

variable "network_rule_collections" {
  description = "List of network rule collections for the Azure Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                  = string
      protocols             = list(string)
      source_addresses      = list(string)
      destination_addresses = list(string)
      destination_ports     = list(string)
    }))
  }))
  default = []
}

variable "nat_rule_collections" {
  description = "List of NAT rule collections for the Azure Firewall Policy Rule Collection Group."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name               = string
      protocols          = list(string)
      source_addresses   = list(string)
      destination_ports  = list(string)
      translated_address = string
      translated_port    = string
    }))
  }))
  default = []
}

variable "firewall_policy_rule_collection_group" {
  description = "Configuration details for the Azure Firewall Policy Rule Collection Group."
  type = object({
    name     = string
    priority = number
  })
  default = {
    name     = "example-fwpolicy-rcg"
    priority = 500
  }
}



