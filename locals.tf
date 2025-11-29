locals {

  # Owners: use explicit list if provided; else fallback list
  group_explicit_owners = try(var.group_settings.owners, null)
  group_owners = (
    local.group_explicit_owners != null && length(local.group_explicit_owners) > 0 ?
    distinct(local.group_explicit_owners) :
    distinct(var.group_default_owner_object_ids)
  )

}
