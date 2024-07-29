# terraform-practice

## Prerequisites

### Secrets

#### TF_TOKEN

A user API token from app.terraform.io to save state to the cloud

#### GH_PAT

A personal access token from Github that has permissions to manage all of the repos you want to manage through Terraform

##### Permissions

* For github_branch_protection - "Administration" repository permissions (write)
* For github_repository_environment - "Administration" repository permissions (write)
