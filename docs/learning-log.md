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
