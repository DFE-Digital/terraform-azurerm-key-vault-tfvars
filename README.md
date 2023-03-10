# terraform-azurerm-key-vault-tfvars

[![Terraform CI](./actions/workflows/continuous-integration-terraform.yml/badge.svg?branch=main)](./actions/workflows/continuous-integration-terraform.yml?branch=main)
[![GitHub release](./releases)](./releases)

This module creates and manages an Azure Key Vault and stores your Terraform variable files as Secrets within it.

## Usage

Example module usage:

```hcl
module "azure_key_vault_tfvars" {
  source = "github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars?ref=v0.1.0"

  environment         = "Dev"
  project_name        = "myproject"
  resource_group_name = "my-rg-name"
  azure_location      = "uk-south"

  key_vault_access_users = [
    "my_email.address.suffix#EXT#@platformidentity.onmicrosoft.com",
  ]

  tfvars_filename = "dev.tfvars"

  tags = {
    "My Tag" = "My Value!"
  }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.3.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.36.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.46.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.tfvars](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.tfvars](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_monitor_diagnostic_setting.tfvars](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azuread_user.key_vault_access](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location in which to launch resources. | `string` | n/a | yes |
| <a name="input_diagnostic_eventhub_name"></a> [diagnostic\_eventhub\_name](#input\_diagnostic\_eventhub\_name) | Specify an Event Hub name to send Diagnostic information to | `string` | `""` | no |
| <a name="input_diagnostic_log_analytics_workspace_id"></a> [diagnostic\_log\_analytics\_workspace\_id](#input\_diagnostic\_log\_analytics\_workspace\_id) | Specify a Log Analytics Workspace ID to send Diagnostic information to | `string` | `""` | no |
| <a name="input_diagnostic_retention_days"></a> [diagnostic\_retention\_days](#input\_diagnostic\_retention\_days) | How many days should Diagnostic Logs be retained for? | `number` | `7` | no |
| <a name="input_diagnostic_storage_account_id"></a> [diagnostic\_storage\_account\_id](#input\_diagnostic\_storage\_account\_id) | Specify a Storage Account ID to send Diagnostic information to | `string` | `""` | no |
| <a name="input_enable_diagnostic_retention_policy"></a> [enable\_diagnostic\_retention\_policy](#input\_enable\_diagnostic\_retention\_policy) | Should a retention policy be enabled for the Diagnostic logs? | `bool` | `true` | no |
| <a name="input_enable_diagnostic_setting"></a> [enable\_diagnostic\_setting](#input\_enable\_diagnostic\_setting) | Enable Azure Diagnostics setting for the Key Vault | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Will be used along with `project_name` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_key_vault_access_users"></a> [key\_vault\_access\_users](#input\_key\_vault\_access\_users) | List of users that require access to the Key Vault where tfvars are stored. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name. Will be used along with `environment` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of an existing Resource Group to create the Key Vault within | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_tfvars_filename"></a> [tfvars\_filename](#input\_tfvars\_filename) | tfvars filename. This file is uploaded and stored encrupted within Key Vault, to ensure that the latest tfvars are stored in a shared place. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
