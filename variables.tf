# NOTE: Terraform does not support top-level custom validation blocks; keeping ownership check implicit.

variable "name" {
  type        = string
  description = "The display name for the Entra ID group."

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 256
    error_message = "The group display name must be between 1 and 256 characters (Microsoft Graph API limit)."
  }
}

variable "allow_role_assignable_group_without_owner" {
  type        = bool
  default     = false
  description = <<DESC
Allows creation of a role-assignable group without any owners. Not recommended.

Why: Owners provide delegated recovery and governance for privileged groups.
Leaving a role-assignable group ownerless can impede lifecycle management and
reduce accountability.

References:
- Microsoft Graph group (isAssignableToRole): https://learn.microsoft.com/graph/api/resources/group?view=graph-rest-1.0
- Assign Azure roles using groups: https://learn.microsoft.com/azure/role-based-access-control/role-assignments-group
- Privileged access groups (PIM): https://learn.microsoft.com/entra/id-governance/privileged-identity-management/groups-features

Set to true only if you fully understand and accept the risk.
DESC
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "group_default_owner_object_ids" {
  type        = list(string)
  default     = []
  description = "Fallback list of owner object IDs when group_settings.owners is not specified. Provide at least one for role-assignable groups."
}

variable "group_description" {
  type        = string
  default     = ""
  description = "A description for the Entra ID group."
}

variable "group_settings" {
  type = object({
    administrative_unit_ids    = optional(list(string))
    assignable_to_role         = optional(bool)
    auto_subscribe_new_members = optional(bool)
    behaviors                  = optional(list(string))
    description                = optional(string)
    external_senders_allowed   = optional(bool)
    hide_from_address_lists    = optional(bool)
    hide_from_outlook_clients  = optional(bool)
    mail_enabled               = optional(bool)
    mail_nickname              = optional(string)
    owners                     = optional(list(string))
    prevent_duplicate_names    = optional(bool)
    provisioning_options       = optional(list(string))
    security_enabled           = optional(bool)
    theme                      = optional(string)
    types                      = optional(list(string))
    visibility                 = optional(string)
    dynamic_membership = optional(object({
      rule             = string
      processing_state = optional(string, "On")
    }))
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  })
  default     = {}
  description = <<DESCRIPTION
Optional settings applied to the Entra ID group beyond the baseline configuration.

## Role-Assignable Groups (`assignable_to_role`)

Role-assignable groups have special properties and limitations that should be considered:

### When Role-Assignable is REQUIRED:
- **Entra ID Role Assignment**: If you want to assign Entra ID (directory) roles to a group, it MUST be role-assignable.
  The `assignable_to_role` property must be set at group creation and cannot be changed afterward.

### When Role-Assignable is RECOMMENDED:
- **Critical Resources**: For groups providing access to sensitive resources, role-assignable groups offer enhanced security:
  - Only Global Administrator, Privileged Role Administrator, or the group Owner can manage the group
  - Only these privileged roles can modify credentials of active group members
  - Prevents privilege escalation by lower-privileged administrators (e.g., Helpdesk Administrator cannot reset passwords of members)

### Important Limitations:
- **500 Group Limit**: Maximum of 500 role-assignable groups per tenant (hard limit)
- **No Nesting**: Role-assignable groups cannot contain other groups as members
- **Immutable Property**: Cannot be changed after group creation
- **Planning Required**: In large environments with many PIM-enabled groups, reserve role-assignable groups for:
  - Groups that need Entra ID role assignments
  - Groups providing access to highly privileged resources
  - Consider using non-role-assignable groups for less critical PIM scenarios (subscription-level access, etc.)

### PIM for Groups Compatibility:
- **Any security group or Microsoft 365 group can use PIM for Groups** (except dynamic membership groups and on-premises synced groups)
- Role-assignable groups are NOT required for PIM for Groups functionality
- This restriction was removed in January 2023, allowing more than 500 PIM-enabled groups per tenant

### Sources:
- [Relationship between role-assignable groups and PIM for Groups](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/concept-pim-for-groups#relationship-between-role-assignable-groups-and-pim-for-groups)
- [What are Microsoft Entra role-assignable groups?](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/concept-pim-for-groups#what-are-microsoft-entra-role-assignable-groups)
- [Create a role-assignable group in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/groups-create-eligible)
DESCRIPTION
}
