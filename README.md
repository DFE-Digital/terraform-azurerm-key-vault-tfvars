# terraform-azurerm-key-vault-tfvars

[![Terraform CI](https://github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars/actions/workflows/continuous-integration-terraform.yml/badge.svg?branch=main)](https://github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars/actions/workflows/continuous-integration-terraform.yml?branch=main)
[![GitHub release](https://github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars/releases)](https://github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars/releases)

This module creates and manages an Azure Key Vault and stores your Terraform variable files as Secrets within it.

## Usage

Example module usage:

```hcl
module "azure_key_vault_tfvars" {
  source = "github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars?ref=v0.2.1"

  environment                = "Dev"
  project_name               = "myproject"
  existing_resource_group    = "my-rg-name"
  enable_resource_group_lock =  false
  azure_location             = "uk-south"

  key_vault_access_users = [
    "my_email.address.suffix#EXT#@platformidentity.onmicrosoft.com",
  ]

  # List of IPV4 Addresses that are permitted to access the Key Vault
  key_vault_access_ipv4 = [
    "8.8.8.8"
  ]

  ## Specify a list of Azure Subnet Resource IDs that can access this Key Vault
  # key_vault_access_subnet_ids = [
  #   "/my/azure/subnet/id"
  # ]

  tfvars_filename     = "dev.tfvars"
  secret_expiry_years = 5

  # enable_diagnostic_setting             = true
  # enable_log_analytics_workspace        = false
  # diagnostic_log_analytics_workspace_id = "my-log-analytics"
  # diagnostic_eventhub_name              = "my-eventhub-name"
  # enable_diagnostic_storage_account     = false
  # diagnostic_storage_account_id         = "my-storage-account-id"

  tags = {
    "My Tag" = "My Value!"
  }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.37.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.43.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.75.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.tfvars](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.tfvars](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_management_lock.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_monitor_diagnostic_setting.tfvars](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azuread_user.key_vault_access](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.existing_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location in which to launch resources. | `string` | n/a | yes |
| <a name="input_diagnostic_eventhub_name"></a> [diagnostic\_eventhub\_name](#input\_diagnostic\_eventhub\_name) | Specify an Event Hub name to send Diagnostic information to | `string` | `""` | no |
| <a name="input_diagnostic_log_analytics_workspace_id"></a> [diagnostic\_log\_analytics\_workspace\_id](#input\_diagnostic\_log\_analytics\_workspace\_id) | Specify a Log Analytics Workspace ID to send Diagnostic information to | `string` | `""` | no |
| <a name="input_diagnostic_storage_account_id"></a> [diagnostic\_storage\_account\_id](#input\_diagnostic\_storage\_account\_id) | Specify a Storage Account ID to send Diagnostic information to | `string` | `""` | no |
| <a name="input_enable_diagnostic_setting"></a> [enable\_diagnostic\_setting](#input\_enable\_diagnostic\_setting) | Enable Azure Diagnostics setting for the Key Vault | `bool` | `true` | no |
| <a name="input_enable_diagnostic_storage_account"></a> [enable\_diagnostic\_storage\_account](#input\_enable\_diagnostic\_storage\_account) | When enabled, creates a Storage Account for the diagnostic logs, if one hasn't been specified for `diagnostic_storage_account_id` | `bool` | `false` | no |
| <a name="input_enable_log_analytics_workspace"></a> [enable\_log\_analytics\_workspace](#input\_enable\_log\_analytics\_workspace) | When enabled, creates a Log Analyics Workspace, if one hasn't been specified for `diagnostic_log_analytics_workspace_id` | `bool` | `false` | no |
| <a name="input_enable_resource_group_lock"></a> [enable\_resource\_group\_lock](#input\_enable\_resource\_group\_lock) | Enabling this will add a Resource Lock to the Resource Group preventing any resources from being deleted. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Will be used along with `project_name` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | Name of an existing Resource Group to create the Key Vault within. If left empty, one will be created. | `string` | `""` | no |
| <a name="input_key_vault_access_ipv4"></a> [key\_vault\_access\_ipv4](#input\_key\_vault\_access\_ipv4) | List of IPv4 Addresses that are permitted to access the Key Vault | `list(string)` | n/a | yes |
| <a name="input_key_vault_access_subnet_ids"></a> [key\_vault\_access\_subnet\_ids](#input\_key\_vault\_access\_subnet\_ids) | List of Azure Subnet IDs that are permitted to access the Key Vault | `list(string)` | `[]` | no |
| <a name="input_key_vault_access_users"></a> [key\_vault\_access\_users](#input\_key\_vault\_access\_users) | List of users that require access to the Key Vault. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name. Will be used along with `environment` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_secret_expiry_years"></a> [secret\_expiry\_years](#input\_secret\_expiry\_years) | Number of years from now when the Key Vault secret should be considered expired | `number` | `5` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_tfvars_filename"></a> [tfvars\_filename](#input\_tfvars\_filename) | tfvars filename. This file is uploaded and stored encrupted within Key Vault, to ensure that the latest tfvars are stored in a shared place. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
