resource "azuread_privileged_access_group_eligibility_schedule" "this" {
  for_each = local.eligibility_schedules

  assignment_type      = each.value.assignment_type
  group_id             = azuread_group.this.id
  principal_id         = each.value.principal_id
  duration             = each.value.duration
  expiration_date      = each.value.expiration_date
  permanent_assignment = each.value.permanent
  start_date           = each.value.start_date
}

resource "azuread_group_role_management_policy" "this" {
  group_id = azuread_group.this.id
  role_id  = local.pim_role_id

  activation_rules {
    maximum_duration                   = local.pim_activation_rules.maximum_duration
    require_approval                   = local.pim_activation_rules.require_approval
    require_justification              = local.pim_activation_rules.require_justification
    require_multifactor_authentication = local.pim_activation_rules.require_mfa
    require_ticket_info                = local.pim_activation_rules.require_ticket_info

    dynamic "approval_stage" {
      for_each = local.pim_activation_rules.approval_stage != null ? [local.pim_activation_rules.approval_stage] : []

      content {
        dynamic "primary_approver" {
          for_each = approval_stage.value.primary_approvers

          content {
            object_id = primary_approver.value.object_id
            type      = primary_approver.value.type
          }
        }
      }
    }
  }
  active_assignment_rules {
    expiration_required                = local.pim_active_assignment_rules.expiration_required
    expire_after                       = local.pim_active_assignment_rules.expire_after
    require_justification              = local.pim_active_assignment_rules.require_justification
    require_multifactor_authentication = local.pim_active_assignment_rules.require_mfa
    require_ticket_info                = local.pim_active_assignment_rules.require_ticket_info
  }
  eligible_assignment_rules {
    expiration_required = local.pim_eligible_assignment_rules.expiration_required
    expire_after        = local.pim_eligible_assignment_rules.expire_after
  }
  notification_rules {
    active_assignments {
      admin_notifications {
        default_recipients    = local.pim_notification_rules.active_assignments.admin_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.active_assignments.admin_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.active_assignments.admin_notifications[0].additional_recipients
      }
      approver_notifications {
        default_recipients    = local.pim_notification_rules.active_assignments.approver_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.active_assignments.approver_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.active_assignments.approver_notifications[0].additional_recipients
      }
      assignee_notifications {
        default_recipients    = local.pim_notification_rules.active_assignments.assignee_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.active_assignments.assignee_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.active_assignments.assignee_notifications[0].additional_recipients
      }
    }
    eligible_activations {
      admin_notifications {
        default_recipients    = local.pim_notification_rules.eligible_activations.admin_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.eligible_activations.admin_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.eligible_activations.admin_notifications[0].additional_recipients
      }
      approver_notifications {
        default_recipients    = local.pim_notification_rules.eligible_activations.approver_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.eligible_activations.approver_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.eligible_activations.approver_notifications[0].additional_recipients
      }
      assignee_notifications {
        default_recipients    = local.pim_notification_rules.eligible_activations.assignee_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.eligible_activations.assignee_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.eligible_activations.assignee_notifications[0].additional_recipients
      }
    }
    eligible_assignments {
      admin_notifications {
        default_recipients    = local.pim_notification_rules.eligible_assignments.admin_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.eligible_assignments.admin_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.eligible_assignments.admin_notifications[0].additional_recipients
      }
      approver_notifications {
        default_recipients    = local.pim_notification_rules.eligible_assignments.approver_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.eligible_assignments.approver_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.eligible_assignments.approver_notifications[0].additional_recipients
      }
      assignee_notifications {
        default_recipients    = local.pim_notification_rules.eligible_assignments.assignee_notifications[0].default_recipients
        notification_level    = local.pim_notification_rules.eligible_assignments.assignee_notifications[0].notification_level
        additional_recipients = local.pim_notification_rules.eligible_assignments.assignee_notifications[0].additional_recipients
      }
    }
  }
}


