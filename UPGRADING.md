# UPGRADING

## Upgrading to 1.3.0

The following breaking changes are introduced in this version:

- Minimum terraform version has been set to v1.3.0.
- Minimum MCAF provider version has been set to v0.4.2 to be compatible with the latest version of service catalogue.
- Default of the variabes `tfe_workspace_branch` and `additional_tfe_workspaces.branch` have been modified from `master` to `main`.
- The variables `additional_tfe_workspaces.global_remote_state` and `tfe_workspace_settings.global_remote_state` are now automatically set to false.
- The variable `region` has no default anymore and is now a mandatory variable.

## Upgrading to 1.1.0

`v1.1.0` is not backwards compatible with `v1.0.0`. First follow the steps to upgrade to `v1.0.0`. The option to automatically create email address with Office 365 has been removed. This upgrade requires the following changes:

- variable `account_settings` no longer supports a field called `create_email_address`.

## Upgrading to 1.0.0

`v1.0.0` is not backward compatible with `v0.4.1` because terraform-aws-mcaf-workspace changed the variables it uses to connect Terraform workspaces to a VCS. This upgrade requires the following changes:

- Variable `tfe_workspace_settings` requires an additional field called `global_remote_state`, either enabling or disabling global remote state on the workspace.
- Variable `tfe_workspace_settings` requires an additional field called `remote_state_consumer_ids`, containing a set of workspace ID's that are allowed access to the global remote state. Set to `null` to share with everyone.
- Variable `tfe_workspace_settings` requires an additional field called `working_directory`, sets the working directory for a workspace. Set to `null` to fall back to module defaults.
- The fields `repository_owner` and `repository_name` have been replaced by a single field called `repository_identifier`, combining the two values into a single field. Set to `null` to disable VCS connection.
- Additional workspaces require fields `global_remote_state` and `remote_state_consumer_ids` to be present.
- Within additional workspaces, the fields `repository_owner` and `repository_name` have been replaced by a single field called `repository_identifier`, combining the two values into a single field. Set to `null` to disable VCS connection.
