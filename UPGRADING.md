# Upgrading to 1.0.0

`v1.0.0` is not backward compatible with `v0.4.1` because terraform-aws-mcaf-workspace changed the variables it uses to connect Terraform workspaces to a VCS. This upgrade requires the following changes:

* Variable `tfe_workspace_settings` requires an additional field called `global_remote_state`, either enabling or disabling global remote state on the workspace.
* Variable `tfe_workspace_settings` requires an additional field called `remote_state_consumer_ids`, containing a set of workspace ID's that are allowed access to the global remote state. Set to `null` to share with everyone.
* Variable `tfe_workspace_settings` requires an additional field called `working_directory`, sets the working directory for a workspace. Set to `null` to fall back to module defaults.
* The fields `repository_owner` and `repository_name` have been replaced by a single field called `repository_identifier`, combining the two values into a single field. Set to `null` to disable VCS connection.
* Additional workspaces require fields `global_remote_state` and `remote_state_consumer_ids` to be present.
* Within additional workspaces, the fields `repository_owner` and `repository_name` have been replaced by a single field called `repository_identifier`, combining the two values into a single field. Set to `null` to disable VCS connection.
