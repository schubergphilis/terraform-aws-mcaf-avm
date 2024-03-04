output "additional_tfe_workspace" {
  value       = { for name, workspace in var.additional_tfe_workspaces : name => module.additional_tfe_workspaces[name].workspace_id }
  description = "Map of any additional Terraform Cloud workspace names and IDs"
}

output "environment" {
  value       = var.account.environment
  description = "The environment name"
}

output "id" {
  value       = module.account.id
  description = "The AWS account ID"
}

output "name" {
  value       = module.account.name
  description = "The AWS account name"
}

output "repository_identifier" {
  value       = var.tfe_workspace.repository_identifier
  description = "The repository identifier if one is specified"
}

output "tfe_workspace_id" {
  value       = try(module.tfe_workspace[0].workspace_id, "")
  description = "Workspace ID of default workspace ID when `create_default_workspace` is true"
}

output "tfe_workspaces" {
  value = concat(
    try([module.tfe_workspace[0]], []),
    try(values(module.additional_tfe_workspaces), []),
  )
  description = "List of Terraform Cloud workspaces"
}

output "workload_permissions_boundary_arn" {
  value       = try(aws_iam_policy.workload_boundary[0].arn, "")
  description = "The ARN of the workload permissions boundary"
}
