# ADR 0002: Container base image and build approach

- Status: accepted
- Date: 2026-11-20

## Context

The demo service is a small Python app. The image should be small, reasonably secure and easy to scan, and must run as a non-root user so it passes Kubernetes `runAsNonRoot` checks later.

## Options considered

1. `python:3.13-slim` with a multi-stage build (starting point in this repo)
2. `python:3.13-alpine`: smaller, but musl libc can cause wheel and compatibility problems
3. Distroless Python: smallest attack surface, but harder to debug
4. Single-stage build: simplest, but ships build tooling and caches

## Decision

Option 1: `python:3.15.2-slim` with multi-stage build.

Measurements after Phase 1:
- Multi-stage build: 71.5 MB (compressed) / 294 MB (uncompressed)
- Single-stage build: 76.9 MB (compressed) / 310 MB (uncompressed)
- Size savings: 5.4 MB (7% reduction) plus build tools not shipped
- Trivy vulnerabilities: 47 HIGH (down from 48 after apt-get upgrade), 0 CRITICAL
- Non-root execution: Verified, runs as uid=10001

Options 3 (distroless) and 4 (single-stage) were not measured in depth. Distroless would be smaller but harder to debug during development. Single-stage is simpler but ships unnecessary build tooling.

## Consequences

- Fixed numeric UID (10001) so Kubernetes can verify non-root.
- Dependencies pinned in `requirements.txt` for reproducible builds.
- Multi-stage build reduces attack surface by not including build tools.
- Some OS-level vulnerabilities remain unfixed upstream (util-linux, ncurses in Debian); acceptable for dev image but should be monitored in production.
- Revisit when CI exists (phase 2): consider image signing and SBOMs.
- Consider distroless for production, but keep multi-stage slim for dev builds.
