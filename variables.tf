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

variable "protection_patterns" {
  type        = list(string)
  description = "List of name patterns using fnmatch sytanx to apply branch protection rules to"
  default     = []
}

variable "long_lived_branches" {
  type        = map(list(string))
  description = "Map of repository names to a list of their long-lived branches that require protection (e.g., {'my-repo': ['development', 'blog']})"
  default     = {}
}

variable "pull_request_review_count" {
  type        = number
  description = "Number of approvals needed before allowing a PR to be merged"
  default     = 2

  validation {
    condition     = var.pull_request_review_count >= 0 && var.pull_request_review_count <= 6
    error_message = "The pull_request_review_count must be between 0 and 6 as per GitHub API limits."
  }
}

variable "collaborators" {
  type        = map(map(string))
  description = "Map of repository names to a map of usernames and their permission level (pull, triage, push, maintain, admin)"
  default     = {}
}
