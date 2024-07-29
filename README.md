# Terraform AZURE Firewall Module
[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png


This Terraform module manages Azure Firewall and its configurations. It provisions Azure Firewalls, Firewall Policy and associated rules, and configures necessary settings.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Usage](#usage)
- [Use Cases](#UseCases)
- [Inputs](#inputs)
- [Outputs](#outputs)



## Introduction

Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. This module provides an easy way to deploy and manage Azure Firewalls using Terraform.

## Features

- Creates an Azure Firewall with specified configurations.
- Manages firewall policies, rule collections (application, network, NAT).
- Supports configuring IP configurations and management IP configurations.
- Allows tagging of resources for better management.
- Provides easy-to-use variables for common configurations.

## Usage

```hcl
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
```


## Use Cases:

1- [Firewall Setup with Multiple Rule Types](https://github.com/OT-terraform-azure-modules/terraform-azure-firewall/tree/feature0.0.1/examples/firewall_setup_with_multiple_rule_types)

  Explore this example to learn how to deploy an Azure Firewall with various rule types using Terraform. This setup ensures comprehensive network security management for your Azure services.



## Inputs

### Resource Group Configuration

| Name                 | Description                                                       | Type     | Default | Required |
|----------------------|-------------------------------------------------------------------|----------|---------|----------|
| `resource_group_name`    | The name of the Resource Group                | `string`      | n/a              | yes      |
| `resource_group_location`| The Location for the Resource Group           | `string`      | n/a              | yes      |
| `lock_level_value`       | Lock level for the Resource Group             | `string`      | `CanNotDelete`   | yes      |


### Virtual Network Configuration

| Name                     | Description                                   | Type          | Default          | Required |
|--------------------------|-----------------------------------------------|---------------|------------------|----------|
| `vnet_name`              | Name of the Virtual Network                   | `list(string)` | n/a              | yes      |
| `address_space`          | Address space of the Virtual Network          | `list(list(any))`| n/a              | yes      |
| `vnet_location`          | Location of the Virtual Network               | `list(string)`      | n/a              | yes      |
| `dns_servers`            | List of DNS servers for the Virtual Network   | `list(string)` | `[]`             | no       |
| `create_ddos_protection_plan`| Whether to create a DDoS Protection Plan| list(bool)       | `[false]`          | no       |


### Subnet Configuration

| Name                              | Description                                    | Type          | Default | Required |
|-----------------------------------|------------------------------------------------|---------------|---------|----------|
| `subnet_name`                     | Name of the subnet                             | 'list(list(string))'    | n/a     | yes      |
| `subnet_address_prefixes`         | Address prefixes of the subnet                 | `list(list(string))'    | n/a     | yes      |
| `service_endpoints`               | Service endpoints for the subnet               | `list(string)`| `[]`    | no       |
| `forced_tunneling`                | Whether to force tunneling                     | `bool`        | `false` | no       |
| `management_subnet_name`          | Name of the management subnet                  | `list(list(string))`      | []    | Optional      |
| `management_subnet_address_prefixes`| Address prefixes of the management subnet   | `list(list(string))       `| []     | yes      |
| `management_subnet_service_endpoints`| Service endpoints for the management subnet| `list(string)`| `[]`    | no       |


### Public IP Configuration

| Name                              | Description                                    | Type          | Default   | Required |
|-----------------------------------|------------------------------------------------|---------------|-----------|----------|
| `public_ip_name`                  | Name of the public IP                          | `list(string)`      | n/a       | yes      |
| `management_public_ip_name`       | Name of the management public IP               | `list(string)`      | n/a       | yes      |
| `public_ip_allocation_method`     | Allocation method for the public IP            | `string`      | `Dynamic`  | yes       |
| `public_ip_sku`                   | SKU for the public IP                          | `string`      | `Basic`| yes       |



### Firewall Configuration

| Name                              | Description                                    | Type          | Default   | Required |
|-----------------------------------|------------------------------------------------|---------------|-----------|----------|
| `firewall_configuration`                | Configuration for the Azure Firewall          | `object`         | { name      = "testfirewall", sku_name  = "AZFW_VNet", sku_tier  = "Standard"}      | yes      |
| `ip_configuration_name`                 | Name of the IP configuration                  | `string`      | 'configuration'      | yes      |
| `firewall_policy_configuration`         | Configuration for the Azure Firewall Policy   | `object`         |  { name = "example-policy", sku = "Standard", threat_intelligence_mode = "Alert" }       | yes      |
| `firewall_policy_rule_collection_group` | Configuration for the Firewall Policy Rule Collection Group | `object` | { name     = "example-fwpolicy-rcg", priority = 500 } | yes |
| `application_rule_collections`          | List of application rule collections           | `list(map)`  | `[]`      | no       |
| `network_rule_collections`              | List of network rule collections               | `list(map)`  | `[]`      | no       |
| `nat_rule_collections`                  | List of NAT rule collections                   | `list(map)`  | `[]`      | no       |


### Additional Configuration

| Name                           | Description                                                       | Type   | Default | Required |
|--------------------------------|-------------------------------------------------------------------|--------|---------|----------|
| tags      | Common Tags for the resources be be create                                     | map(string)   | Name of the resource     | no      |
| create_resource_group      | Whether to create the Resource Group                              | bool   | true     | no      |


## Outputs

| Name                                             | Description                                                    |
|--------------------------------------------------|----------------------------------------------------------------|
| <a name="output_resource_group_name"></a> resource_group_name | The name of the resource group.                                 |
| <a name="output_resource_group_location"></a> resource_group_location | The location of the resource group.                             |
| <a name="output_vnet_id"></a> vnet_id           | The ID of the virtual network.                                  |
| <a name="output_subnet_ids"></a> subnet_ids     | The IDs of the subnets.                                        |
| <a name="output_management_subnet_id"></a> management_subnet_id | The ID of the management subnet.                                |
| <a name="output_public_ip_id"></a> public_ip_id | The ID of the public IP.                                       |
| <a name="output_management_public_ip_id"></a> management_public_ip_id | The ID of the management public IP.                             |
| <a name="output_firewall_id"></a> firewall_id   | The ID of the Azure Firewall.                                  |
| <a name="output_firewall_policy_id"></a> firewall_policy_id | The ID of the Azure Firewall Policy.                            |
| <a name="output_firewall_policy_rule_collection_group_id"></a> firewall_policy_rule_collection_group_id | The ID of the Azure Firewall Policy Rule Collection Group. |


## Contributors
- [Kuldeep Singh](https://www.linkedin.com/in/kuldeep-singh-9702b879/) 
- [Rajat Vats](https://www.linkedin.com/in/rajat-vats-32042aa9/)