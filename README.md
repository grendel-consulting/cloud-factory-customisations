# Cloud Factory (Account) Customisations

Definitions for use with the Account Factory for Terraform (AFT) framework. Account Customizations are used to customize **specific** provisioned accounts with customer defined resources. The resources can be created through Terraform or through Python, leveraging the API helpers. The customization run is parameterized at runtime.

## Usage

Start by using the the ACCOUNT_TEMPLATE, copying into a new folder. It's name should match the `account_customizations_name` provided in the account request for the account(s) being configured in this way.

### Terraform

You can see AFT-provided Jinja templates for the Terraform backend and providers. These are rendered at the time the Terraform is applied. Further providers can be defined by creating a `providers.tf` file, as needed.

Define your own Terraform resources, placing `.tf` files in the 'terraform' directory or as submodules to it.

### API Helpers

Define any scripts that need to run before/after Terraform using the bash entry points. You can extend these to run Python scripts or to perform other actions, such as leveraging the AWS CLI.

Within the `api_helpers/python` folder is a requirements.txt, where you can specify packages to be installed via PIP.

## Further Reading

See: [AFT Account Customizations](https://github.com/aws-ia/terraform-aws-control_tower_account_factory/tree/main/sources/aft-customizations-repos/aft-account-customizations)