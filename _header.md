# terraform-azuread-avm-res-pim-group

A module in the style of Azure Verified Modules for managing an Entra ID Privileged Identity Management (PIM) group.

The original intention was to use the `msgraph` provider, however blocking issues were identified.

Instead, this approach uses the traditional `azuread` provider from Hashicorp for the group and PIM resources.

An experimental `msgraph` approach which records the current status of issues is available here:
<https://github.com/kewalaka/terraform-msgraph-avm-ptn-pim-group>

## Graph Permissions (Minimum Application Permissions)

| Capability | Permissions |
|------------|-------------|
| Create / Update Group | `Group.ReadWrite.All`, `Directory.ReadWrite.All` |
| Role-Assignable Group | `RoleManagement.ReadWrite.Directory` |
| Group PIM Eligibility Requests | `PrivilegedAccess.ReadWrite.AzureADGroup` |

## Technical notes

### Coverage

The module supports the following as illustrated by examples:

- **Eligible Users** ("PIM for groups").  This is the recommended approach for most scenarios, where a group is permanently assigned the role and users are eligible to request access to this group.  This provides per-user visibility for activation requests.

- **Group-Assignable**.  In this approach the group is activated into the role rather than an individual user.  This is not recommended except for specific circumstances (Microsoft recommend this approach for some M365 portals).  Further details and a comparison with "PIM for groups" are in the example [README.md](examples/group-eligible/README.md).

- **Standard Security Groups**.  Demonstrates PIM features on a standard security group (not role-assignable). This is suitable for Azure Resource RBAC scenarios where the group does not need to hold Entra ID roles.

### Ownership Enforcement

Role-assignable groups must declare at least one owner via `group_settings.owners` or `group_default_owner_object_ids`; enforced with resource lifecycle precondition.

### Role Definition Resolution Pattern

Name→ID resolution handled by helper module mapping; IDs pass through unchanged. Fallback preserves user-supplied value if unmapped (supports custom roles defined at narrower scopes if user supplies full ID).
