data "github_branch_protection_rules" "my_rules" {
  # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/branch_protection_rules
  for_each = toset(data.github_repositories.my_topics.names)

  repository = each.key
}

import {
  for_each = tomap({
    for ext in local.existing_rules : "${ext.repository} - ${ext.rule_name}" => ext
  })

  to = github_branch_protection.rules[each.key]
  id = "${each.value.repository}:${each.value.rule_name}"
}

data "github_repository_environments" "my_envs" {
  # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository_environments
  for_each = toset(data.github_repositories.my_topics.names)

  repository = each.key
}

import {
  for_each = tomap({
    for ext in local.existing_envs : "${ext.repository} - ${ext.env_name}" => ext
  })

  to = github_repository_environment.environments[each.key]
  id = "${each.value.repository}:${each.value.env_name}"
}
