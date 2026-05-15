resource "azurerm_subnet" "tfvars_subnet" {
  count = local.enable_private_endpoint ? 1 : 0

  name                              = "${local.resource_prefix}tfvars"
  virtual_network_name              = local.virtual_network_name
  resource_group_name               = local.resource_group.name
  address_prefixes                  = [local.key_vault_subnet_cidr]
  private_endpoint_network_policies = "Enabled"
}
