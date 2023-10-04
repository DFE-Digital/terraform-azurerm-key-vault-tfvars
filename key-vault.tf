resource "azurerm_key_vault" "tfvars" {
  name                       = "${local.resource_prefix}-tfvars"
  location                   = local.azure_location
  resource_group_name        = local.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  enable_rbac_authorization  = false
  purge_protection_enabled   = true

  dynamic "access_policy" {
    for_each = data.azuread_user.key_vault_access

    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value["object_id"]

      key_permissions = local.key_vault_key_permissions

      secret_permissions = [
        "Set",
        "Get",
        "Delete",
        "Purge",
        "Recover",
        "List",
      ]
    }
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = length(local.key_vault_access_ipv4) > 0 ? local.key_vault_access_ipv4 : null
    virtual_network_subnet_ids = length(local.key_vault_access_subnet_ids) > 0 ? local.key_vault_access_subnet_ids : null
  }

  tags = local.tags
}

data "azurerm_key_vault_encrypted_value" "encrypted" {
  count = local.encrypt_tfvars ? 1 : 0

  key_vault_key_id = azurerm_key_vault_key.generated[0].id
  algorithm        = "RSA1_5"
  plain_text_value = base64encode(file(local.tfvars_filename))
}

resource "azurerm_key_vault_secret" "tfvars" {
  name            = "${local.resource_prefix}-tfvars"
  value           = local.encrypt_tfvars ? base64encode(file(local.tfvars_filename)) : data.azurerm_key_vault_encrypted_value.encrypted[0].encrypted_data
  key_vault_id    = azurerm_key_vault.tfvars.id
  content_type    = "text/plain+base64"
  expiration_date = local.year_from_now

  tags = local.tags
}

resource "azurerm_key_vault_key" "generated" {
  count = local.generate_key_vault_key ? 1 : 0

  name            = "${local.resource_prefix}-tfvars"
  key_vault_id    = azurerm_key_vault.tfvars.id
  key_type        = "RSA"
  key_size        = 4096
  expiration_date = local.year_from_now

  key_opts = [
    "decrypt",
    "encrypt",
    "verify",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }

  tags = local.tags
}