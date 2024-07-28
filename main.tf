provider "github" {
  owner = var.github_owner
  token = var.github_token
}

data "github_repositories" "my_topics" {
  query = "user:${var.github_owner} topic:practice"
}

resource "github_repository_environment" "environments" {
  for_each = {
    for repo in data.github_repositories.my_topics : repo.name => [
      for env in local.environments : {
        repository  = repo.name
        environment = env
      }
    ]
  }

  repository = each.value.repository
  environment = each.value.environment
}
