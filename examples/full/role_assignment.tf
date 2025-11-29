
resource "azurerm_role_assignment" "example" {
  principal_id         = module.privileged_group.group_id
  scope                = local.subscription_scope
  role_definition_name = "Owner"
}
