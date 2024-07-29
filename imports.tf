data "github_branch_protection_rules" "my_rules" {
  # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository_environments
  for_each   = toset(data.github_repositories.my_topics.names)
  repository = each.key
}

import {
  for_each = toset([
    for repo in data.github_repositories.my_topics : repo if contains([for rule in data.github_branch_protection_rules.my_rules[repo].rules : rule.pattern], "{main,master}")
  ])

  to = github_branch_protection.main[each.key]
  id = "${each.key}:{main,master}"
}

data "github_repository_environments" "my_envs" {
  # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository_environments
  for_each   = toset(data.github_repositories.my_topics.names)
  repository = each.key
}

import {
  for_each = tomap({
    for ext in local.existing_envs : "${ext.repository} - ${ext.env_name}" => ext
  })

  to = github_repository_environment.environments[each.key]
  id = "${each.value.repository}:${each.value.env_name}"
}