# terraform-practice

## Gotchas

### Searching for Forked Repos

GitHub does not index forks, so the query in `data.github_repositories.my_topics` will never find any repos created as a fork.

### Searching for Private Repos

Unless you are paying money to GitHub, the query in `data.github_repositories.my_topics` will probably NOT find your private repos.

### Explicit Management (The `managed_repos` Solution)

To overcome the limitations of the topic-based search, this configuration uses a `managed_repos` local variable. This variable combines repositories discovered via topics with any repository explicitly mentioned in:

*   `long_lived_branches`
*   `collaborators`

**This means you can manage private repositories and forks** simply by adding them to one of these variables in your `terraform.tfvars` file. Once added, Terraform will fetch their data directly (bypassing search) and apply all standard protection rules and collaborator settings.

## Prerequisites

### Secrets

#### TF_TOKEN

A user API token from app.terraform.io to save state to the cloud

#### GH_PAT

A personal access token from GitHub that has permissions to manage all of the repos you want to manage through Terraform

##### Permissions

* For github_branch_protection - "Administration" repository permissions (write)
* For github_repository_environment - "Administration" repository permissions (write)

### GitHub Environment Setup (For CI Deployments)

The GitHub Actions workflow that applies changes (`update-repos.yml`) uses a GitHub Environment to pause for manual approval before executing `terraform apply`. For this to work, you must manually configure the environment in this repository's settings:

1.  Navigate to your repository on GitHub.
2.  Click on **Settings** -> **Environments**.
3.  Click **New environment** and name it exactly: `terraform-apply`.
4.  In the environment settings, check the box for **Required reviewers**.
5.  Search for and add your own GitHub username as a reviewer.
6.  Click **Save protection rules**.

When you merge code to the default branch, the workflow will generate a plan and then wait for you to review and click "Approve and Apply" from the Actions tab.

## Pull Request Review Process

By default, the branch protection rules enforced by this configuration require **2 approvals** before a pull request can be merged. 

### Admin Bypass for Personal Projects

For personal projects, getting two approvals might be impractical or slow. Because this configuration does not strictly enforce branch protection rules on repository administrators (the `enforce_admins` setting is not enabled), you have an "Admin Bypass":

*   **Your own PRs:** You can merge your own PRs at any time by using your administrator privileges to bypass the required reviews.
*   **Contributor PRs:** If a contributor opens a PR, they will be blocked until they get 2 approvals. However, as the repository owner, you can provide 1 approval and then use your admin privileges to override the second requirement and merge the code.

### Using CODEOWNERS

If you find that the default requirement of 2 approvals is too restrictive even for contributors, you can update the `pull_request_review_count` variable to `1`. In doing so, it is highly recommended to implement a `CODEOWNERS` file in your repositories. This ensures that the single required approval comes from a designated code owner, maintaining a strong level of security and oversight.

### Protecting Long-Lived Branches

By default, this configuration automatically protects the **default branch** (e.g., `main`, `master`, `gh-pages`) of every managed repository, as well as any branches matching the `protection_patterns` list (which defaults to an empty list `[]`).

If you use a GitFlow-like model where certain repositories have additional long-lived branches (like `development`, `staging`, or `blog`) that also require protection rules, you can specify them using the `long_lived_branches` variable.

This variable takes a map where the key is the repository name and the value is a list of the long-lived branches for that specific repo:

```hcl
long_lived_branches = {
  "my-frontend-repo"  = ["development"]
  "my-fullstack-repo" = ["development", "blog", "uat"]
}
```

These branches will receive the exact same protection rules (review requirements, linear history, etc.) as the default branch.

### Managing Collaborators

If you want to invite outside contributors to specific repositories, you can manage their access via code using the `collaborators` variable. This provides a clear audit trail of who has access to which repository and at what permission level.

The variable takes a map of repository names to a map of usernames and their desired permission level. The available permission levels are:

*   **`pull`**: Read-only access. Best for non-code contributors who want to view or discuss the project.
*   **`triage`**: Can manage issues and pull requests (apply labels, close/reopen, assign) without having push access to the code.
*   **`push`**: Read and write access. The standard role for contributors actively pushing commits to feature branches.
*   **`maintain`**: Can push code and manage some repository settings (like managing issues/PRs), but cannot change sensitive settings like repository visibility or delete the repository.
*   **`admin`**: Full access to the repository, including sensitive and destructive actions.

```hcl
collaborators = {
  "my-awesome-project" = {
    "contributor-github-handle" = "push"
    "another-developer"         = "triage"
  }
}
```
