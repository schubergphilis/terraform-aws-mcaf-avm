# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## 1.3.0 (2022-11-03)

ENHANCEMENTS

- Modify variables to optional variables in the `additional_tfe_workspaces` and `tfe_workspace_settings` variable and add support for setting the workspace team access ([#22](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/22))

## 1.2.1 (2022-01-27)

BUG FIXES

- Bumped mcaf workspace to to v0.7.1: Fix group attachment when not adding a group with the group variable ([#20](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/20))

## 1.2.0 (2022-01-14)

ENHANCEMENTS

- Bumped mcaf workspace to to v0.7.0 ([#19](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/19))

## 1.1.0 (2021-12-29)

ENHANCEMENTS

- Bumped mcaf account to v0.5.0 and removed "create_email_address" from account settings ([#18](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/18))

## 1.0.0 (2021-11-16)

ENHANCEMENTS

- Update tfe_workspace to support setting a Terraform working directory directly ([#17](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/17))
- Bump mcaf workspace to v0.6.0 to add support for managing global remote state ([#17](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/17))

## 0.4.1 (2021-10-13)

ENHANCEMENTS

- Updates tfe_workspace to also set clear_text_terraform_variables in the workspace so it works the same as additional_tfe_workspaces ([#16](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/16))

## 0.4.0 (2021-09-16)

ENHANCEMENTS

- Adds account_settings.create_email_address variable ([#15](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/15))
- GH provider has been moved to intergations/ ([#12](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/12))
- Bumps mcaf workspace to mitigate warning: does not declare a provider ([#11](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/11))
- Update terraform-aws-mcaf-workspace to v0.5.0 ([#10](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/10))

BUG FIXES

- Removes vars that should've been updated when bumping workspace module from 0.3.x to 0.5.x ([#13](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/13))

## 0.3.2 (2021-04-07)

ENHANCEMENTS

- Add support for custom username name ([#9](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/9))

## 0.3.1 (2021-04-02)

ENHANCEMENTS

- Add support for custom workspace name ([#8](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/8))

## 0.3.0 (2021-04-01)

ENHANCEMENTS

- Add support for all available MCAF workspace variables ([#7](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/7))

## 0.2.3 (2021-03-26)

BUG FIXES

- Fix bug in `additional_tfe_workspace` output ([#5](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/5)) ([#6](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/6))

## 0.2.2 (2021-03-24)

ENHANCEMENTS

- Add support for passing HCL variables to the tfe workspaces ([#4](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/4))

## 0.2.1 (2021-03-24)

ENHANCEMENTS

- Add account/environment variables to the additional tfe workspaces ([#3](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/3))

## 0.2.0 (2021-03-23)

ENHANCEMENTS

- Upgrade TFE workspace module to 0.3.1 ([#2](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/2))

## 0.1.0 (2021-02-26)

- First version ([#1](https://github.com/schubergphilis/terraform-aws-mcaf-avm/pull/1))
