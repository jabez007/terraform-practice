locals {
  environments = ["Development", "UAT", "Production"]

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
      for env in local.environments : {
        repository  = repo
        environment = env
      }
    ]
  ])
}