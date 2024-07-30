# terraform-practice

## Gotchas

### Searching for Forked Repos

Github does not index forks, so the query in data.github_repositories.my_topics will never find any repos created as a fork

### Searching for Private Repos

Unless you are paying money to Github, the query in data.github_repositories.my_topics will probably NOT find your private repos

## Prerequisites

### Secrets

#### TF_TOKEN

A user API token from app.terraform.io to save state to the cloud

#### GH_PAT

A personal access token from Github that has permissions to manage all of the repos you want to manage through Terraform

##### Permissions

* For github_branch_protection - "Administration" repository permissions (write)
* For github_repository_environment - "Administration" repository permissions (write)
