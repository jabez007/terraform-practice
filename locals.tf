locals {
  user_reviewers = (length(var.user_reviewers) == 0 && length(var.team_reviewers) == 0) ? [var.github_owner] : var.user_reviewers

  managed_repos = distinct(concat(
    data.github_repositories.my_topics.names,
    keys(var.long_lived_branches),
    keys(var.collaborators)
  ))

  #### https://developer.hashicorp.com/terraform/language/functions/flatten#flattening-nested-structures-for-for_each
  # create a list of objects
  # [
  #   {
  #     repository: "repo1",
  #     environment: "Development"
  #   },
  #   {
  #     repository: "repo1",
  #     environment: "UAT"
  #   },
  #   {
  #     repository: "repo1",
  #     environment: "Production"
  #   }  
  # ]
  ####
  repo_environments = flatten([
    for repo in local.managed_repos : [
      for env in var.environments : {
        repository  = repo
        environment = env
      }
    ]
  ])

  existing_envs = flatten([
    for repo in local.managed_repos : [
      for env in data.github_repository_environments.my_envs[repo].environments : {
        repository = repo
        env_name   = env.name
      } if(contains(var.environments, env.name))
    ]
  ])

  repo_protection_patterns = {
    for repo in local.managed_repos :
    repo => distinct(concat(
      [data.github_repository.repos[repo].default_branch],
      var.protection_patterns,
      lookup(var.long_lived_branches, repo, [])
    ))
  }
  branch_rules = flatten([
    for repo, patterns in local.repo_protection_patterns : [
      for pat in patterns : {
        repository = repo
        pattern    = pat
      }
    ]
  ])

  existing_rules = flatten([
    for repo in local.managed_repos : [
      for rule in data.github_branch_protection_rules.my_rules[repo].rules : {
        repository   = repo
        rule_pattern = rule.pattern
      } if(contains(local.repo_protection_patterns[repo], rule.pattern))
    ]
  ])

  repo_collaborators = flatten([
    for repo, users in var.collaborators : [
      for username, permission in users : {
        repository = repo
        username   = username
        permission = permission
      }
    ]
  ])
}
