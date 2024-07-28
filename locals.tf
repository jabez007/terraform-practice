locals {
  environments = ["Development", "UAT", "Production"]

  ####
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
      for env in local.environments : {
        repository = repo
        environment = env
      }
    ]
  ])
}