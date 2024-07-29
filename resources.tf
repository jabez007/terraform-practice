data "github_repositories" "my_topics" {
  # https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
  query = "user:${var.github_owner} topic:practice"
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/user
data "github_user" "current" {
  username = "" # Retrieve information about the currently authenticated user.
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
