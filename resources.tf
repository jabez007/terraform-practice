data "github_user" "current" { # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/user
  username = var.github_owner  # Retrieve information about the currently authenticated user.
}

data "github_repositories" "my_topics" { # https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repositories
  # https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
  query = "user:${var.github_owner} topic:practice"
}

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
    users = each.value.environment == "Production" ? [data.github_user.current.id] : []
  }
}
