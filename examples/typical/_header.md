# Typical Example: PIM for Groups with Nested Eligibility

This scenario demonstrates a scalable "PIM for Groups" pattern where eligibility is managed through a nested security group rather than individual user assignments.

In this configuration, an "Operations Team" group is made eligible for the PIM-enabled group. Users added to the Operations Team automatically inherit this eligibility. When they need elevated permissions, they activate their membership in the PIM-enabled group individually. This allows you to manage who is eligible simply by managing the membership of the Operations Team group.

## What the example builds

- **PIM-Enabled Group**: A role-assignable security group that holds a permanent `Contributor` role assignment on the subscription.
- **Operations Team**: A standard security group containing the operators.
- **Nested Eligibility**: The Operations Team is assigned as an *eligible member* of the PIM-Enabled Group.
- **Demo Identities**: Creates a PIM approver and an operator user. The operator is a member of the Operations Team.
- **PIM Policy**: Configured to require MFA, approval, and a 4-hour activation window.

## Permissions required

Run this example with the same app registration or credentials you use for the full demo. The identity must have:

- Azure RBAC: `User Access Administrator` (or `Owner`) for the subscription.
- Microsoft Graph application permissions:
  - `Domain.Read.All`
  - `User.Read.All`
  - `User.ReadWrite.All`
  - `Group.Read.All`
  - `Group.ReadWrite.All`
  - `PrivilegedAccess.ReadWrite.AzureADGroup`
  - `PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup`
  - `PrivilegedEligibilitySchedule.Remove.AzureADGroup`
  - `RoleManagementPolicy.ReadWrite.AzureADGroup`
  - `RoleManagement.ReadWrite.Directory`
  - `Directory.ReadWrite.All`

Grant and admin-consent these scopes on the service principal, then run `terraform init`, `terraform plan`, and `terraform apply` inside this folder.

## References

- [Privileged Identity Management (PIM) for Groups – Making group of users eligible for Microsoft Entra role](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/concept-pim-for-groups#making-group-of-users-eligible-for-microsoft-entra-role)
