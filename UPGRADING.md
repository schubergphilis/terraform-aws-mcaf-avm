# UPGRADING

## Upgrading to v6.0.0

`v6.0.0` introduces a change that is not backwards compatible when the `name` property of `var.additional_tfe_workspaces` is specified and a different key is used in the provided map. Currently, the key is utilized to generate the role name, ignoring the specified `name` property. To correctly override the name field, it should also be used to create the `role_name`. To upgrade without any issues, ensure that the key matches the name in the provided `additional_tfe_workspaces`.

## Upgrading to v5.0.0

`v5.0.0` is not backwards compatible with `v4.4.0` due to the deprecation of `tfe_workspace.trigger_prefixes` & `additional_tfe_workspaces.trigger_prefixes`.

### Variables (v5.0.0)

- Variable removed: `tfe_workspace.trigger_prefixes` & `additional_tfe_workspaces.trigger_prefixes`.
- Default value added: `tfe_workspace.trigger_patterns`. `null` -> `["modules/**/*"]`.

### Behaviour (v5.0.0)

Terraform Cloud now defaults to **trigger patterns** instead of **trigger prefixes**. Trigger prefixes will be deprecated in the future, so migration is recommended.
Trigger patterns provide greater flexibility, efficiency, and control over how your workspaces respond to changes in your repositories. To simplify the module and avoid unnecessary complexity, support for `trigger_prefixes` has been removed.

#### What You Need to Do

If you are using the module's defaults for these variables, you do not need to do anything. The workspaces will automatically be modified to use trigger patterns.
If you have modified the defaults, you will need to take action otherwise Terraform will fail.

#### How to migrate to `trigger_patterns`

1. **Remove** the `trigger_prefixes` input when using this module
2. **Set** equivalent values in `trigger_patterns`

**Example:**

```hcl
# Before
tfe_workspace.trigger_prefixes = ["envs/prod/"]

# After
tfe_workspace.trigger_patterns = ["envs/prod/**/*"]
```

See [documentation on trigger runs when files in specified paths change](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings/vcs#only-trigger-runs-when-files-in-specified-paths-change).

## Upgrading to v4.0.0

### Variables (v4.0.0)

- The variable `assessments_enabled` has been introduced with default set to `true`.
- The default `auth_method` has been modified from `iam_user` to `iam_role_oidc`.
- The variable `notification_configuration` has been modified from a `list(object)` to a `map(object)`. They key should be the name of the notification configuration as it will be displayed in Terraform Cloud.

### Outputs (v4.0.0)

- `additional_tfe_workspace` has been renamed to `additional_tfe_workspaces`.

### Behaviour (v4.0.0)

- The variables `account`, `environment`, and `workload_permissions_boundary_arn` are now consolidated into a single variable set per account.
This change reduces the total number of Terraform resources needed by allowing this set to be linked to workspaces, rather than duplicating variables for each one.
Upgrading to this version will recreate these variables.
To add more account-specific variables, use the `account_variable_set` resource.

## Upgrading to v3.0.0

3.0.0 introduces new optional variables and removes existing optional variables. Upgrading requires changes if you currently use the `slack_notification_triggers` or `slack_notification_url` variables.

### Variables (v3.0.0)

In both `var.additional_tfe_workspaces` and `var.tfe_workspaces`:

- Added `workspace_tags`
- The `slack_notification_triggers` & `slack_notification_url` variables have been merged into `notification_configuration`. This allows to easily configure notifications for both slack and teams.

## Upgrading to v2.0.0

2.0.0 is a major refactor to make use of `optional`. This commit also introduces breaking changes while we consolidate variables that previously were optional but could not be part of an object (because we had no way to make specific object keys optional).

### Variables (v2.0.0)

- Renamed `var.account_settings` to `var.account`
- Renamed `var.tfe_workspace_settings` to `var.tfe_workspace`
- Renamed `var.tfe_workspace_settings.terraform_organization` to `var.tfe_workspace.organization`
- Moved variables with a `tfe_workspace_` prefix into `var.tfe_workspace` (and removed the prefix)

### Behaviour (v2.0.0)

- `var.account.environment` (was `var.account_settings.environment`) is now an optional value
- The region configured in the workspace is now set using `var.tfe_workspace.default_region` (was `var.region`) and has been made mandatory
- `var.tfe_workspace.branch` now defaults to `main` to follow the community standard, if using `master` be sure to set this in your workspace configurations
- `var.tfe_workspace.global_remote_state` now defaults to `false`, you will now need to set any workspace IDs that need access to this state
- Additional workspaces now inherit the following values from the default workspace unless specified:
  - `auth_method`
  - `branch`
  - `execution_mode`
  - `oauth_token_id`
  - `region`
  - `repository_identifier`
  - `slack_notification_triggers`
  - `slack_notification_url`
  - `ssh_key_id`
  - `team_access`
  - `terraform_version`
  - `trigger_prefixes`
  - `working_directory`
- [terraform-aws-mcaf-account module](https://github.com/schubergphilis/terraform-aws-mcaf-account) updated to v0.5.1: Fixes deprecation warning by using `organizational_unit_path` instead of `organizational_unit`. This will generate a change in plan and will attempt to update the account via Service Catalog. Service Catalog will "re-enrol" the account as it is not smart enough to realise the current OU and target OU are the same, so a ~10 min apply while this happens is expected and a one time event.

Updated requirements:

- Minimum terraform version has been set to v1.3.0
- Minimum MCAF provider version has been set to v0.4.2 to be compatible with the latest version of service catalogue

## Upgrading to v1.1.0

`v1.1.0` is not backwards compatible with `v1.0.0`. First follow the steps to upgrade to `v1.0.0`. The option to automatically create email address with Office 365 has been removed.

### Variables (v1.1.0)
This upgrade requires the following changes:

- variable `account_settings` no longer supports a field called `create_email_address`.

## Upgrading to v1.0.0

`v1.0.0` is not backward compatible with `v0.4.1` because terraform-aws-mcaf-workspace changed the variables it uses to connect Terraform workspaces to a VCS.

### Variables (v1.0.0)
This upgrade requires the following changes:

- Variable `tfe_workspace_settings` requires an additional field called `global_remote_state`, either enabling or disabling global remote state on the workspace.
- Variable `tfe_workspace_settings` requires an additional field called `remote_state_consumer_ids`, containing a set of workspace ID's that are allowed access to the global remote state. Set to `null` to share with everyone.
- Variable `tfe_workspace_settings` requires an additional field called `working_directory`, sets the working directory for a workspace. Set to `null` to fall back to module defaults.
- The fields `repository_owner` and `repository_name` have been replaced by a single field called `repository_identifier`, combining the two values into a single field. Set to `null` to disable VCS connection.
- Additional workspaces require fields `global_remote_state` and `remote_state_consumer_ids` to be present.
- Within additional workspaces, the fields `repository_owner` and `repository_name` have been replaced by a single field called `repository_identifier`, combining the two values into a single field. Set to `null` to disable VCS connection.
