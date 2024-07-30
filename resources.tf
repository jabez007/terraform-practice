data "github_user" "reviewers" { # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/user
  for_each = toset(local.user_reviewers)

  username = each.key
}

data "github_team" "reviewers" { # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/team
  for_each = toset(var.team_reviewers)

  slug = each.key
}

data "github_repositories" "my_topics" { # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repositories
  # https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
  query = var.github_org != "" ? "org:${var.github_org} topic:${join("topic:", var.topics)}" : "user:${var.github_owner} topic:${join("topic:", var.topics)}"
}

/*
resource "github_branch_protection" "main" { # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
  for_each = toset(data.github_repositories.my_topics.names)

  repository_id = each.key
  pattern       = "{main,master}"

  # https://docs.github.com/en/rest/branches/branch-protection
  required_pull_request_reviews {
    required_approving_review_count = 2
    dismiss_stale_reviews           = true # Dismiss approved reviews automatically when a new commit is pushed
  }
}
*/

resource "github_repository_environment" "environments" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # local.repo_environments is a list of objects
  # so we must project that into a map
  # where each key is unique
  for_each = tomap({
    for env in local.repo_environments : "${env.repository} - ${env.environment}" => env
  })

  # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment
  repository  = each.value.repository
  environment = each.value.environment

  reviewers {
    users = contains(var.environments, each.value.environment) ? [for user in data.github_user.reviewers : user.id] : []
    teams = contains(var.environments, each.value.environment) ? [for team in data.github_team.reviewers : team.id] : []
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}
