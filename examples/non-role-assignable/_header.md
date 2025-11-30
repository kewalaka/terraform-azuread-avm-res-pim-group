# Non-Role-Assignable Group Example

This example demonstrates creating a standard Entra ID security group (not role-assignable) with PIM (Privileged Identity Management) enabled.

## Why use this pattern?

- **Avoid Limits**: Entra ID has a hard limit of 500 role-assignable groups per tenant. Standard groups do not have this limit.
- **Resource Access**: These groups work perfectly for Azure Resource RBAC (e.g., Contributor on a Subscription).
- **Limitations**: These groups **cannot** be assigned Entra ID roles (e.g., Global Administrator, User Administrator).

## What the example builds

- A standard security group (`assignable_to_role = false`).
- An owner user who is also an eligible member.
- PIM onboarding is triggered automatically by the eligible member assignment.
