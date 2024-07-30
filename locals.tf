locals {
  user_reviewers = (length(var.user_reviewers) == 0 && length(var.team_reviewers) == 0) ? [var.github_owner] : var.user_reviewers

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
    for repo in data.github_repositories.my_topics.names : [
      for env in var.environments : {
        repository  = repo
        environment = env
      }
    ]
  ])

  existing_envs = flatten([
    for repo in data.github_repositories.my_topics.names : [
      for env in data.github_repository_environments.my_envs[repo].environments : {
        repository = repo
        env_name   = env.name
      } if(contains(var.environments, env.name))
    ]
  ])

  branch_rules = flatten([
    for repo in data.github_repositories.my_topics.names : [
      for pat in var.protection_patterns : {
        repository = repo
        pattern    = pat
      }
    ]
  ])

  existing_rules = flatten([
    for repo in data.github_repositories.my_topics.names : [
      for rule in data.github_branch_protection_rules.my_rules[repo].rules : {
        repository   = repo
        rule_pattern = rule.pattern
      } if(contains(var.protection_patterns, rule.pattern))
    ]
  ])
}
