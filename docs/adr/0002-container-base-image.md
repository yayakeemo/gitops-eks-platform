# ADR 0002: Container base image and build approach

- Status: proposed (finish this in your own words after phase 1)
- Date: YYYY-MM-DD

## Context

The demo service is a small Python app. The image should be small, reasonably secure and easy to scan, and must run as a non-root user so it passes Kubernetes `runAsNonRoot` checks later.

## Options considered

1. `python:3.13-slim` with a multi-stage build (starting point in this repo)
2. `python:3.13-alpine`: smaller, but musl libc can cause wheel and compatibility problems
3. Distroless Python: smallest attack surface, but harder to debug
4. Single-stage build: simplest, but ships build tooling and caches

## Decision

Start with option 1. Measure image size and Trivy findings for options 1, 3 and 4 and record the numbers here before marking this accepted.

## Consequences

- Fixed numeric UID (10001) so Kubernetes can verify non-root.
- Dependencies pinned in `requirements.txt` for reproducible builds.
- Revisit when CI exists (phase 2): consider image signing and SBOMs.
