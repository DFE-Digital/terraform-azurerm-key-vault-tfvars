variable "environment" {
  description = "Environment name. Will be used along with `project_name` as a prefix for all resources."
  type        = string
}

variable "project_name" {
  description = "Project name. Will be used along with `environment` as a prefix for all resources."
  type        = string
}

variable "existing_resource_group" {
  description = "Name of an existing Resource Group to create the Key Vault within"
  type        = string
}

variable "enable_resource_group_lock" {
  description = "Enabling this will add a Resource Lock to the Resource Group preventing any resources from being deleted."
  type        = bool
  default     = false
}

variable "azure_location" {
  description = "Azure location in which to launch resources."
  type        = string
}

variable "key_vault_access_users" {
  description = "List of users that require access to the Key Vault. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform"
  type        = list(string)
}

variable "key_vault_access_ipv4" {
  description = "List of IPv4 Addresses that are permitted to access the Key Vault"
  type        = list(string)
}

variable "key_vault_access_subnet_ids" {
  description = "List of Azure Subnet IDs that are permitted to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "tfvars_filename" {
  description = "tfvars filename. This file is uploaded and stored encrupted within Key Vault, to ensure that the latest tfvars are stored in a shared place."
  type        = string
}

variable "enable_diagnostic_setting" {
  description = "Enable Azure Diagnostics setting for the Key Vault"
  type        = bool
  default     = true
}

variable "diagnostic_log_analytics_workspace_id" {
  description = "Specify a Log Analytics Workspace ID to send Diagnostic information to"
  type        = string
  default     = ""
}

variable "diagnostic_eventhub_name" {
  description = "Specify an Event Hub name to send Diagnostic information to"
  type        = string
  default     = ""
}

variable "diagnostic_storage_account_id" {
  description = "Specify a Storage Account ID to send Diagnostic information to"
  type        = string
  default     = ""
}

variable "enable_diagnostic_retention_policy" {
  description = "Should a retention policy be enabled for the Diagnostic logs?"
  type        = bool
  default     = true
}

variable "diagnostic_retention_days" {
  description = "How many days should Diagnostic Logs be retained for?"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
