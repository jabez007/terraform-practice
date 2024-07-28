provider "github" {
  token = var.github_token
}

data "github_repositories" "my_topics" {
  query = "user:@me topic:practice"
}

resource "github_repository_environment" "environments" {
  for_each = {
    for repo in data.github_repositories.my_topics.results : repo.name => repo.name
  }

  repository = each.value

  dynamic "environment" {
    for_each = local.environments
    content {
      name = environment.value
    }
  }
}
