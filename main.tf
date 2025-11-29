# Group and role assignment resources



resource "azuread_group" "this" {
  display_name       = var.name
  assignable_to_role = coalesce(var.group_settings.assignable_to_role, true)
  description = (
    var.group_settings.description != null ? var.group_settings.description :
    (trimspace(var.group_description) != "" ? var.group_description : null)
  )
  mail_enabled = coalesce(var.group_settings.mail_enabled, false)
  mail_nickname = coalesce(
    try(var.group_settings.mail_nickname, null),
    lower(substr(join("", regexall("[A-Za-z0-9]", var.name)), 0, 64))
  )
  owners           = local.group_owners
  security_enabled = coalesce(var.group_settings.security_enabled, true)
  types            = coalesce(try(var.group_settings.types, null), [])
  visibility       = coalesce(var.group_settings.visibility, "Private")

  dynamic "dynamic_membership" {
    for_each = var.group_settings.dynamic_membership != null ? [var.group_settings.dynamic_membership] : []

    content {
      enabled = dynamic_membership.value.processing_state == "On"
      rule    = dynamic_membership.value.rule
    }
  }

  lifecycle {
    precondition {
      condition = (
        !(coalesce(var.group_settings.assignable_to_role, true)) ||
        length(local.group_owners) > 0 ||
        var.allow_role_assignable_group_without_owner
      )
      error_message = "Role-assignable groups should have at least one owner (delegation and recovery best practice). See: Graph isAssignableToRole (https://learn.microsoft.com/graph/api/resources/group?view=graph-rest-1.0) and Assign roles using groups (https://learn.microsoft.com/azure/role-based-access-control/role-assignments-group). To bypass (not recommended), set allow_role_assignable_group_without_owner = true."
    }
  }
}





