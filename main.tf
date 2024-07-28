provider "github" {
  owner = var.github_owner
  token = var.github_token
}

data "github_repositories" "my_topics" {
  query = "user:${var.github_owner} topic:practice"
}

resource "github_repository_environment" "environments" {
  # local.repo_environments is a list of objects
  # so we must project that into a map
  # where each key is unique
  for_each = tomap({
    for env in local.repo_environments : "${env.repository} - ${env.environment}" => env
  })

  repository  = each.value.repository
  environment = each.value.environment
}
