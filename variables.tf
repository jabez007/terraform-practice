variable "github_owner" {
  type        = string
  description = "Github owner for running actions"
}

variable "github_token" {
  type        = string
  description = "Github token for running actions"
  sensitive   = true
}

variable "github_org" {
  type        = string
  description = "Github origanization to search for repos in"
  default     = ""
}

variable "topics" {
  type        = list(string)
  description = "List of topics used to select repos"
  default     = ["terraformed"]
}

variable "environments" {
  type        = list(string)
  description = "List of environments to set up for selected repos"
  default     = ["Production"]
}

variable "user_reviewers" {
  type        = list(string)
  description = "List of usernames to add as reviewers for given environments"
  default     = []
}

variable "team_reviewers" {
  type        = list(string)
  description = "List of team slugs to add as reviewers for given environments"
  default     = []
}