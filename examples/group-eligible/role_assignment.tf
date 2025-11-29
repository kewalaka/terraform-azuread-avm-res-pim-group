
resource "azurerm_pim_eligible_role_assignment" "example" {
  principal_id       = module.privileged_group.group_id
  role_definition_id = "${local.subscription_scope}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
  scope              = local.subscription_scope
  justification      = "Group-level activation required for legacy process."

  schedule {
    expiration {
      duration_hours = 4
    }
  }
  ticket {
    number = "CHG0005678"
    system = "ServiceNow"
  }
}
