resource "azurerm_key_vault" "tfvars" {
  name                       = "${local.resource_prefix}-tfvars"
  location                   = local.azure_location
  resource_group_name        = local.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  enable_rbac_authorization  = false

  dynamic "access_policy" {
    for_each = data.azuread_user.key_vault_access

    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value["object_id"]

      key_permissions = [
        "Create",
        "Get",
      ]

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

  # It won't be possible to add/manage a network acl for this
  # vault, as it will need to be accessable for multiple people.
  # tfsec:ignore:azure-keyvault-specify-network-acl
  network_acls {
    bypass         = "None"
    default_action = "Allow"
  }

  purge_protection_enabled = true

  tags = local.tags
}

# Expiry doesn't need to be set, as this is just used as a way to
# store and share the tfvars
# tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "tfvars" {
  name         = "${local.resource_prefix}-tfvars"
  value        = base64encode(file(local.tfvars_filename))
  key_vault_id = azurerm_key_vault.tfvars.id
  content_type = "text/plain+base64"
}
