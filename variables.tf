variable "github_owner" {
  type        = string
  description = "Github owner for running actions"
}

variable "github_token" {
  type        = string
  description = "Github token for running actions"
  sensitive   = true
}