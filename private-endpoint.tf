resource "azurerm_private_endpoint" "kv" {
  count = local.enable_private_endpoint ? 1 : 0

  name                = "${local.resource_prefix}-kv.${azurerm_key_vault.tfvars.name}"
  location            = data.azurerm_resource_group.existing_resource_group[0].location
  resource_group_name = data.azurerm_resource_group.existing_resource_group[0].name
  subnet_id           = azurerm_subnet.tfvars_subnet[0].id

  custom_network_interface_name = "${local.resource_prefix}-${azurerm_key_vault.tfvars.name}-nic"

  private_service_connection {
    name                           = "${local.resource_prefix}-${azurerm_key_vault.tfvars.name}"
    private_connection_resource_id = azurerm_key_vault.tfvars.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = local.tags
}

resource "azurerm_private_dns_zone" "kv_private_link" {
  count = local.enable_private_endpoint ? 1 : 0

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.existing_resource_group[0].name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_private_link" {
  count = local.enable_private_endpoint ? 1 : 0

  name                  = "${local.resource_prefix}kvprivatelink"
  resource_group_name   = data.azurerm_resource_group.existing_resource_group[0].name
  private_dns_zone_name = azurerm_private_dns_zone.kv_private_link[0].name
  virtual_network_id    = local.virtual_network_id
  tags                  = local.tags
}

resource "azurerm_private_dns_a_record" "kv_private_link" {
  count = local.enable_private_endpoint ? 1 : 0

  name                = azurerm_key_vault.tfvars.name
  zone_name           = azurerm_private_dns_zone.kv_private_link[0].name
  resource_group_name = data.azurerm_resource_group.existing_resource_group[0].name
  ttl                 = 300
  records             = [azurerm_private_endpoint.kv[0].private_service_connection[0].private_ip_address]
  tags                = local.tags
}
