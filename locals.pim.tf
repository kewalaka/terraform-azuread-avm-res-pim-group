locals {
  # PIM Activation Rules
  default_activation_rules = {
    maximum_duration      = var.pim_activation_max_duration
    require_approval      = var.pim_require_approval_on_activation
    require_justification = true
    require_ticket_info   = false
    require_mfa           = var.pim_require_mfa_on_activation
    approval_stage        = null
  }
  # PIM Active Assignment Rules
  default_active_assignment_rules = {
    expiration_required   = false
    expire_after          = "P365D"
    require_justification = true
    require_ticket_info   = false
    require_mfa           = false
  }
  # PIM Eligible Assignment Rules
  default_eligible_assignment_rules = {
    expiration_required   = false
    expire_after          = var.pim_eligibility_duration
    require_justification = true
    require_ticket_info   = false
    require_mfa           = false
  }
  default_notification_settings = {
    admin_notifications    = [{ notification_level = "All", default_recipients = false, additional_recipients = [] }]
    assignee_notifications = [{ notification_level = "All", default_recipients = true, additional_recipients = [] }]
    approver_notifications = [{ notification_level = "All", default_recipients = true, additional_recipients = [] }]
  }
  # Merge them
  eligibility_schedules = merge(local.eligible_members_map, local.eligible_schedules_map)

  # Convert list to map
  # Use index as key to allow for unknown principal_ids (e.g. created in same apply)
  eligible_members_map = {
    for idx, principal_id in var.eligible_members : "member-idx-${idx}" => {
      principal_id    = principal_id
      assignment_type = "member"
      start_date      = null
      expiration_date = null
      duration        = null
      permanent       = true
    }
  }
  # Process detailed map
  eligible_schedules_map = {
    for k, v in var.eligible_member_schedules : k => {
      principal_id    = v.principal_id
      assignment_type = coalesce(v.assignment_type, "member")
      start_date      = v.start_date
      expiration_date = v.expiration_date
      duration        = v.duration
      permanent       = coalesce(v.permanent_assignment, false)
    }
  }
  pim_activation_rules = merge(local.default_activation_rules, local.user_activation_rules, {
    approval_stage = (coalesce(try(local.user_activation_rules.require_approval, null), local.default_activation_rules.require_approval)) ? {
      primary_approvers = [
        for id in var.pim_approver_object_ids : {
          object_id = id
          type      = var.pim_approver_object_type
        }
      ]
    } : null
  })
  pim_active_assignment_rules   = merge(local.default_active_assignment_rules, local.user_active_assignment_rules)
  pim_eligible_assignment_rules = merge(local.default_eligible_assignment_rules, local.user_eligible_assignment_rules)
  pim_notification_rules = {
    active_assignments = {
      admin_notifications    = try(local.user_notification_rules.active_assignments[0].admin_notifications, null) != null ? local.user_notification_rules.active_assignments[0].admin_notifications : local.default_notification_settings.admin_notifications
      approver_notifications = try(local.user_notification_rules.active_assignments[0].approver_notifications, null) != null ? local.user_notification_rules.active_assignments[0].approver_notifications : local.default_notification_settings.approver_notifications
      assignee_notifications = try(local.user_notification_rules.active_assignments[0].assignee_notifications, null) != null ? local.user_notification_rules.active_assignments[0].assignee_notifications : local.default_notification_settings.assignee_notifications
    }
    eligible_assignments = {
      admin_notifications    = try(local.user_notification_rules.eligible_assignments[0].admin_notifications, null) != null ? local.user_notification_rules.eligible_assignments[0].admin_notifications : local.default_notification_settings.admin_notifications
      approver_notifications = try(local.user_notification_rules.eligible_assignments[0].approver_notifications, null) != null ? local.user_notification_rules.eligible_assignments[0].approver_notifications : local.default_notification_settings.approver_notifications
      assignee_notifications = try(local.user_notification_rules.eligible_assignments[0].assignee_notifications, null) != null ? local.user_notification_rules.eligible_assignments[0].assignee_notifications : local.default_notification_settings.assignee_notifications
    }
    eligible_activations = {
      admin_notifications    = try(local.user_notification_rules.eligible_activations[0].admin_notifications, null) != null ? local.user_notification_rules.eligible_activations[0].admin_notifications : local.default_notification_settings.admin_notifications
      approver_notifications = try(local.user_notification_rules.eligible_activations[0].approver_notifications, null) != null ? local.user_notification_rules.eligible_activations[0].approver_notifications : local.default_notification_settings.approver_notifications
      assignee_notifications = try(local.user_notification_rules.eligible_activations[0].assignee_notifications, null) != null ? local.user_notification_rules.eligible_activations[0].assignee_notifications : local.default_notification_settings.assignee_notifications
    }
  }
  # PIM Role ID
  # Default to "member" as this module is for Group PIM.
  # Can be overridden by var.pim_policy_settings.role_id if needed.
  pim_role_id                    = coalesce(var.pim_policy_settings.role_id, "member")
  user_activation_rules          = try(var.pim_policy_settings.activation_rules[0], {})
  user_active_assignment_rules   = try(var.pim_policy_settings.active_assignment_rules[0], {})
  user_eligible_assignment_rules = try(var.pim_policy_settings.eligible_assignment_rules[0], {})
  # PIM Notification Rules
  user_notification_rules = try(var.pim_policy_settings.notification_rules[0], {})
}
