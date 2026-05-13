resource "azurerm_monitor_action_group" "main" {
  count = local.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-actiongroup"
  resource_group_name = local.resource_group.name
  short_name          = local.project_name
  tags                = local.tags

  dynamic "email_receiver" {
    for_each = local.monitor_email_receivers

    content {
      name                    = "Email ${email_receiver.value}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "kv_delete" {
  count = local.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-kv-delete"
  resource_group_name = local.resource_group.name
  location            = local.resource_group.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_log_analytics_workspace.key_vault[0].id]

  severity    = 1
  description = "Key Vault delete/purge operations detected"

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where ResourceProvider == "MICROSOFT.KEYVAULT"
      | where OperationName has_any (
          "SecretDelete",
          "KeyDelete",
          "CertificateDelete",
          "SecretPurge",
          "KeyPurge",
          "CertificatePurge"
      )
    KQL

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [
      azurerm_monitor_action_group.main[0].id
    ]
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "kv_failed_access" {
  count = local.enable_monitoring ? 1 : 0

  name                = "${local.resource_prefix}-kv-failed-access"
  resource_group_name = local.resource_group.name
  location            = local.resource_group.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_log_analytics_workspace.key_vault[0].id]

  severity    = 2
  description = "Spike in forbidden or unauthorized Key Vault access"

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where ResourceProvider == "MICROSOFT.KEYVAULT"
      | where ResultType in ("403", "Forbidden", "Unauthorized")
      | summarize Count = count()
          by CallerIPAddress, identity_claim_upn_s, bin(TimeGenerated, 5m)
      | where Count >= 10
    KQL

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [
      azurerm_monitor_action_group.main[0].id
    ]
  }
}
