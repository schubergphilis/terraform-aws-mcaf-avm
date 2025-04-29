# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## v6.2.2 - 2025-04-29

### What's Changed

#### 🐛 Bug Fixes

* fix: output permission boundary names (#73) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v6.2.1...v6.2.2

## v6.2.1 - 2025-03-28

### What's Changed

#### 🐛 Bug Fixes

* fix: set default for var.tfe_workspace.set_working_directory to true (#72) @sbkg0002

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v6.2.0...v6.2.1

## v6.2.0 - 2025-03-26

### What's Changed

#### 🚀 Features

* enhancement: Ignore terraform_version when "" is provided in var.additional_tfe_workspaces.terraform_version (#71) @sbkg0002

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v6.1.0...v6.2.0

## v6.1.0 - 2025-03-17

### What's Changed

Note: This version bumps the Terraform required version to `>= 1.7.0`, due to dependency requirements.

#### 🚀 Features

* enhancement: bump aws-mcaf-workspace to 2.5.x (#70) @mlflr

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v6.0.1...v6.1.0

## v6.0.1 - 2025-02-27

### What's Changed

#### 🐛 Bug Fixes

* bug: allow the working directory to not be set (#69) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v6.0.0...v6.0.1

## v6.0.0 - 2025-02-26

### What's Changed

#### 🚀 Features

* breaking: generate the role from name if supplied (#68) @Plork

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v5.0.0...v6.0.0

## v5.0.0 - 2025-02-24

### What's Changed

#### 🚀 Features

* breaking: deprecate trigger_prefixes (#67) @noobnesz

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.4.0...v5.0.0

## v4.4.0 - 2025-01-28

### What's Changed

#### 🚀 Features

* feat(options): Add speculative_enabled option  (#66) @stromp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.3.1...v4.4.0

## v4.3.1 - 2025-01-10

### What's Changed

#### 🐛 Bug Fixes

* fix: solve issue with using coalesce on null values (#65) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.3.0...v4.3.1

## v4.3.0 - 2025-01-10

### What's Changed

#### 🚀 Features

* feature: Support GitHub app for VCS connections, solve deprecation warnings (#64) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.2.0...v4.3.0

## v4.2.0 - 2024-10-29

### What's Changed

#### 🚀 Features

* feature: add the region environmental variable to the variable set instead of to each workspace (#63) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.1.0...v4.2.0

## v4.1.0 - 2024-09-19

### What's Changed

#### 🚀 Features

* enhancement: bumps aws-mcaf-workspace module, note this version recreates the variable AWS_DEFAULT_REGION. (#62) @stefanwb

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.0.3...v4.1.0

## v4.0.3 - 2024-08-08

### What's Changed

#### 🐛 Bug Fixes

* fix: resolving an error in the inheritance behaviour of `notification_configuration` and `team_access` (#61) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.0.2...v4.0.3

## v4.0.2 - 2024-08-07

### What's Changed

#### 🐛 Bug Fixes

* fix: modify notification-settings behaviour to take "tfe_workspace"  value (#60) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.0.1...v4.0.2

## v4.0.1 - 2024-08-06

### What's Changed

#### 🐛 Bug Fixes

* fix: merge var.account_variable_set.clear_text_terraform_variables into local (#59) @jorrite

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v4.0.0...v4.0.1

## v4.0.0 - 2024-08-05

### What's Changed

#### 🚀 Features

* breaking: solve bug where `notification_configuration` can not contain sensitive values or values known after apply (#58) @marwinbaumannsbp
* feat: account variable set (#55) @jorrite
* breaking: set default auth mode from 'iam_user' to 'iam_role_oidc' and modify outputs (#57) @marwinbaumannsbp
* feature: add support for the newest variables in mcaf-workspace, set `assessments_enabled` to true by default as is best practise, optimize optionals (#56) @marwinbaumannsbp

#### 🐛 Bug Fixes

* breaking: solve bug where `notification_configuration` can not contain sensitive values or values known after apply (#58) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v3.0.3...v4.0.0

## v3.0.3 - 2024-05-16

### What's Changed

#### 🐛 Bug Fixes

* fix: add workspace_permissions_boundary_arn output (#53) @marwinbaumannsbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v3.0.2...v3.0.3

## v3.0.2 - 2024-04-30

### What's Changed

#### 🐛 Bug Fixes

* fix: Setting `working_directory` shouldn't depend on a VCS connection (#49) @borisroman

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v3.0.1...v3.0.2

## v3.0.1 - 2024-03-04

### What's Changed

#### 🐛 Bug Fixes

* fix(output): Add outputs for other modules to consume (#52) @shoekstra

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v3.0.0...v3.0.1

## v3.0.0 - 2024-03-01

### What's Changed

#### 🚀 Features

* breaking: update notification variables & add workspace tags for workspace submodule (#51) @marlonparmentier

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v2.12.0...v3.0.0

## v2.12.0 - 2024-02-22

### What's Changed

#### 🚀 Features

* feature: make all runs configurable (#50) @stromp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v2.11.0...v2.12.0

## v2.11.0 - 2023-09-07

### What's Changed

#### 🚀 Features

- feat: Add OIDC support (#48) @wvanheerde

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v2.10.0...v2.11.0

## v2.10.0 - 2023-06-07

### What's Changed

#### 🚀 Features

- feat: make permissions boundary conditional for workspaces (#47) @sbkg0002

#### 📖 Documentation

- feat: make permissions boundary conditional for workspaces (#47) @sbkg0002

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v2.9.0...v2.10.0

## v2.9.0 - 2023-05-26

### What's Changed

#### 🚀 Features

- feat: do not set certain vcs related values when `connect_vcs_repo` has been set to false (#46) @davealtenasbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v2.8.0...v2.9.0

## v2.8.0 - 2023-04-24

### What's Changed

- Remove workflows (#40) @shoekstra

#### 🚀 Features

- feat: make the creation of TFE repositories optional (#44) @davealtenasbp

#### 📖 Documentation

- feat: make the creation of TFE repositories optional (#44) @davealtenasbp

**Full Changelog**: https://github.com/schubergphilis/terraform-aws-mcaf-avm/compare/v2.7.1...v2.8.0

## 2.7.1 - 2023-02-15

- Add default_tags to provider configuration. ([#39] https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/39))

## 2.7.0 - 2023-02-02

- Changed agent_role_arn to agent_role_arns, to support multiple agent pools to assume the role. ([#38] https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/38))

## 2.6.0 - 2023-01-24

- Add path variable which can be used to set a path for all supported IAM resources  ([#37] https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/37))

## 2.5.0 - 2023-01-20

- Add path variable to the tfe_workspace and additional_tfe_workspace ([#35] https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/35))

## 2.4.0 - 2023-01-18

- Bumped [terraform-aws-mcaf-workspace](https://github.com/schubergphilis/terraform-aws-mcaf-workspace) module to v0.13.0: Adds support to specify workspace project ID ([#36](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/36))

## 2.3.1 - 2023-01-17

- Create additional Terraform Cloud workspace variable when permissions boundaries are configured. ([#34](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/34))

## 2.3.0 - 2023-01-16

- Adds support for setting alternate contacts on account level ([#30](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/30))

## 2.2.0 - 2023-01-12

- Adds support for permissions boundaries by adding 'workspace_boundary' and 'workload_boundary' IAM policies ([#31](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/31))

## 2.1.1 - 2023-01-11

BUG FIXES

- Fix `clear_text_terraform_variables` in additional workspaces ([#32](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/32))

## 2.1.0 - 2023-01-03

- Bumped [terraform-aws-mcaf-workspace](https://github.com/schubergphilis/terraform-aws-mcaf-workspace) module to v0.10.0: Adds support to use custom workspace permissions ([#29](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/29))

ENHANCEMENTS

## 2.0.1 - 2022-12-12

ENHANCEMENTS

- `aws_assume_role_external_id` will now be set to `sensitive` in Terraform Cloud workspaces in order to prevent `assume_role` leakage ([#28](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/28))

## 2.0.0 - 2022-11-15

BUG FIXES

- The `working_directory` variable defaulted to "terraform" instead of "terraform/${var.account.environment}" as is expected behaviour ([#25](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/25))

ENHANCEMENTS

- Update existing variables to support `optional` now that Terraform 1.3 -- Please see [UPGRADING.md](./UPGRADING.md) for more information ([#24](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/24))
- Bumped [terraform-aws-mcaf-account](https://github.com/schubergphilis/terraform-aws-mcaf-account) module to v0.5.1: Adds support to specify an OU path to provision an account into a nested OU ([#23](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/23))
- Modify variables to optional variables in the `additional_tfe_workspaces` and `tfe_workspace_settings` variable and add support for setting the workspace team access ([#22](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/22))
- Bumped [terraform-aws-mcaf-workspace](https://github.com/schubergphilis/terraform-aws-mcaf-workspace) to v0.9.0 to support using IAM roles as a way for workspaces to authenticate to AWS (instead of creating an IAM user) ([#21](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/21))
- Inherit more from `var.tfe_workspace` ([#26](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/26))
- Use CamelCase to compute additional workspace IAM role or usernames ([#27](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/27))

## 1.2.1 - 2022-01-27

BUG FIXES

- Bumped terraform-aws-mcaf-workspace module to v0.7.1: Fix IAM user group attachment when not specifying additional groups ([#20](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/20))

## 1.2.0 - 2022-01-14

ENHANCEMENTS

- Bumped terraform-aws-mcaf-workspace module to v0.7.0 ([#19](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/19))

## 1.1.0 - 2021-12-29

ENHANCEMENTS

- Bumped terraform-aws-mcaf-avm module to v0.5.0 and removed "create_email_address" from account settings ([#18](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/18))

## 1.0.0 - 2021-11-16

ENHANCEMENTS

- Update tfe_workspace to support setting a Terraform working directory directly ([#17](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/17))
- Bump terraform-aws-mcaf-workspace module to v0.6.0 to add support for managing global remote state ([#17](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/17))

## 0.4.1 - 2021-10-13

ENHANCEMENTS

- Updates tfe_workspace to also set clear_text_terraform_variables in the workspace so it works the same as additional_tfe_workspaces ([#16](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/16))

## 0.4.0 - 2021-09-16

ENHANCEMENTS

- Adds account_settings.create_email_address variable ([#15](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/15))
- GH provider has been moved to intergations/ ([#12](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/12))
- Bumps terraform-aws-mcaf-workspace module to mitigate warning: does not declare a provider ([#11](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/11))
- Update terraform-aws-mcaf-workspace to v0.5.0 ([#10](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/10))

BUG FIXES

- Removes vars that should've been updated when bumping workspace module from 0.3.x to 0.5.x ([#13](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/13))

## 0.3.2 - 2021-04-07

ENHANCEMENTS

- Add support for custom username name ([#9](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/9))

## 0.3.1 - 2021-04-02

ENHANCEMENTS

- Add support for custom workspace name ([#8](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/8))

## 0.3.0 - 2021-04-01

ENHANCEMENTS

- Add support for all available terraform-aws-mcaf-workspace module variables ([#7](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/7))

## 0.2.3 - 2021-03-26

BUG FIXES

- Fix bug in `additional_tfe_workspace` output ([#5](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/5)) ([#6](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/6))

## 0.2.2 - 2021-03-24

ENHANCEMENTS

- Add support for passing HCL variables to the tfe workspaces ([#4](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/4))

## 0.2.1 - 2021-03-24

ENHANCEMENTS

- Add account/environment variables to the additional tfe workspaces ([#3](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/3))

## 0.2.0 - 2021-03-23

ENHANCEMENTS

- Upgrade TFE workspace module to 0.3.1 ([#2](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/2))

## 0.1.0 - 2021-02-26

- First version ([#1](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/1))
