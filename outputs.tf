

output "group_id" {
  description = "The ID of the created Entra ID group (Microsoft Graph group id)."
  value       = azuread_group.this.object_id
}

output "group_object_id" {
  description = "The Object ID of the created Entra ID group (same as group_id)."
  value       = azuread_group.this.object_id
}

output "resource_id" {
  description = "The Azure resource ID of the Entra ID group. This output is required by Azure Verified Modules specification RMFR7."
  value       = azuread_group.this.object_id
}
