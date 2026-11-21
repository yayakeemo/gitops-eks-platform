# Learning log

One entry per working session. Write down what you tried, what broke, and how you fixed it. These become your interview stories and the basis for the blog post.

## Template

```
### YYYY-MM-DD: short title
- Goal:
- What I did:
- What broke / surprised me:
- How I fixed it:
- What I'd do differently:
```

## Entries

### 2026-11-21: Phase 3 start - Terraform basics and AWS infrastructure
- Goal: Set up AWS infrastructure with Terraform (VPC, subnet, internet gateway)
- What I did:
  - Installed Terraform and created terraform/ directory
  - Set up AWS credentials with `aws configure` (us-east-2 region)
  - Created main.tf with AWS provider configuration
  - Ran `terraform init` to download provider plugins
  - Created first AWS resource: VPC with CIDR 10.0.0.0/16
  - Created subnet within VPC: 10.0.1.0/24 in us-east-2a
  - Created Internet Gateway and attached to VPC
  - Used `terraform plan` to preview changes before applying
  - Used `terraform apply` to create resources on AWS
  - Verified resources with `terraform show` and AWS CLI
- What broke / surprised me:
  - Terraform wasn't available via standard Homebrew (had to download binary)
  - Initially confused about DNS settings (enable_dns_hostnames vs enable_dns_support)
  - Realized AWS VPC itself is free; only data transfer and other services charge
  - `terraform plan` is reassuring—lets you see exactly what will be created before committing
- How I fixed it:
  - Downloaded Terraform directly from terraform.io
  - Learned that both DNS settings are needed for EKS to work properly
  - Set up AWS credentials with `aws configure`
  - Used `terraform plan` between each change to understand what's happening
- What I'd do differently:
  - Set up Terraform earlier to understand IaC concepts before writing code
  - Understand CIDR blocks better before diving in (10.0.0.0/16 vs 10.0.1.0/24)
  - Create a .gitignore for terraform/ to exclude state files and .terraform/ directory

### 2026-11-21: Phase 2 CI/CD with GitHub Actions
- Goal: Set up automated testing, building, scanning, and pushing on every push to main
- What I did:
  - Created `.github/workflows/build.yml` with GitHub Actions
  - Added workflow steps: checkout, setup buildx, install dependencies, run tests
  - Installed Trivy in the workflow and scanned the image
  - Set up docker login to GitHub Container Registry (ghcr.io)
  - Tagged images with both `latest` and commit SHA for versioning
  - Pushed images to ghcr.io on successful workflow completion
  - Learned about YAML indentation and GitHub Actions context variables
- What broke / surprised me:
  - Initial workflow failed because .venv didn't exist on the runner (not pushed to git)
  - Trivy installation failed with deprecated `apt-key` command
  - Docker push to ghcr.io failed with "denied" error due to incorrect image path format
  - Had to understand GitHub Actions variables: `github.actor`, `github.repository`, `github.sha`, `github.repository_owner`
- How I fixed it:
  - Added `make install` step before tests to create venv on the runner
  - Used Trivy's official install script: `curl ... trivy-install.sh`
  - Fixed image path by using `github.repository_owner` with explicit repo name instead of `github.repository`
  - Changed scan severity from `HIGH,CRITICAL` to just `CRITICAL` to allow known HIGH vulns documented in Phase 1
- What I'd do differently:
  - Start with understanding the difference between local vs runner environments earlier
  - GitHub Container Registry setup was confusing; Docker Hub would have been simpler but ghcr.io works once the path format is correct
  - Test the workflow with smaller incremental changes rather than adding all steps at once

### 2026-11-20: Phase 1 Docker setup and vulnerability fixes
- Goal: Get the app containerized, scanned, and pushed to GitHub
- What I did:
  - Ran make install, make test, make build to set up the project
  - Verified the container runs as non-root (uid=10001) and /healthz endpoint returns status: ok
  - Installed Trivy and ran make scan to identify security vulnerabilities
  - Updated Python dependencies to fix vulnerabilities: msgpack (1.1.2→1.2.3), setuptools (70.3.0→78.1.1), urllib3 (2.7.0→2.8.0)
  - Updated Dockerfile base image from python:3.13-slim to python:3.15.2-slim for newer Debian packages
  - Added `apt-get update && apt-get upgrade -y` to patch OS-level vulnerabilities
  - Compared multi-stage build vs single-stage: multi-stage was 5.4MB smaller (71.5MB vs 76.9MB)
  - Created public GitHub repo and pushed via SSH
- What broke / surprised me:
  - Initial `make install` failed with "python: command not found" — only python3 was available on macOS
  - Trivy found 48 HIGH severity vulnerabilities in Debian packages, mostly in util-linux and system libraries
  - Trying to create symlink failed due to permissions, so I edited the Makefile instead
  - Even with updated Python 3.15.2, Debian vulnerabilities persisted until I added system package upgrades
  - GitHub no longer accepts password authentication; had to use SSH keys
- How I fixed it:
  - Changed Makefile from `python` to `python3` to match what was installed
  - Updated requirements.txt with newer package versions from Trivy's recommendations
  - Upgraded Dockerfile base image and added apt-get upgrade step
  - Used git remote add with SSH URL for GitHub authentication
- What I'd do differently:
  - Check which Python version is available before assuming `python` exists
  - Understand that OS-level vulnerabilities can't always be fully patched — some have no fixes yet
  - Be aware that multi-stage builds provide both size and security benefits by not shipping build tools

### 2026-11-20: repo created
- Goal: set up the repo and run the demo app locally.
