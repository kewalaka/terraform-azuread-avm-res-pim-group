
resource "azurerm_pim_eligible_role_assignment" "example" {
  principal_id       = module.privileged_group.group_id
  scope              = local.subscription_scope
  role_definition_id = "${local.subscription_scope}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
  justification      = "Group-level activation required for legacy process."
  schedule {
    expiration {
      duration_hours = 4
    }
  }
  ticket {
    system = "ServiceNow"
    number = "CHG0005678"
  }
}
