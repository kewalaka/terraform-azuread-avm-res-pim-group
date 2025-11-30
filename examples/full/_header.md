# Full Example

This example demonstrates the comprehensive capabilities of the module, showcasing a wide range of configuration options for PIM groups. It is designed to illustrate how to handle complex governance requirements, including detailed PIM policies, eligible member scheduling, and group settings.

## What the example builds

- **Complex PIM Policy**: Configures detailed activation rules including:
  - MFA requirements.
  - Ticket information requirements.
  - Approval workflows with specific approvers.
  - Custom notification settings for admins, assignees, and approvers.
- **Eligible Member Scheduling**: Sets up eligible assignments for users with specific schedules, durations, and justifications (e.g., "Operations on-call rotation").
- **Group Configuration**: Creates a role-assignable group with multiple owners and specific settings (security enabled, mail disabled).
- **Demo Identities**: Provisions multiple Entra ID users to act as primary admins, secondary admins, and duty managers (approvers) to simulate a real-world team structure.
- **RBAC Assignment**: Assigns the group the `Owner` role on the current subscription (via `role_assignment.tf`).

## Usage

This example is useful for understanding how to:

- Implement strict governance controls using PIM policies.
- Pre-configure eligible members with specific time-bound access.
- Customize notifications for PIM events.
- Manage group ownership and settings in detail.
