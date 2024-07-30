terraform {
  required_providers {
    github = { # https://registry.terraform.io/providers/integrations/github/latest/docs
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  cloud { # https://developer.hashicorp.com/terraform/cli/cloud/settings
    organization = "mccann-hub"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces { # block must contain exactly one of either tags or name argument
      name = "terraform-practice"
    }

    # token = TF_TOKEN_hostname # host-specific environment variable
  }
}
