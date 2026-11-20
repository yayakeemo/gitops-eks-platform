# ADR 0001: Record architecture decisions

- Status: accepted
- Date: YYYY-MM-DD

## Context

This project is a learning platform, and the reasoning behind each choice matters as much as the result. Without a written record, the "why" is forgotten quickly.

## Options considered

1. No written record: fast, but the reasoning is lost.
2. Long design documents up front: heavy, and they go stale.
3. Short ADRs written when a decision is made: lightweight and versioned with the code.

## Decision

Use short ADRs in `docs/adr/`, one per significant decision, using `0000-template.md`.

## Consequences

Each phase adds one or more ADRs (for example: base image, Terraform state layout, Karpenter vs Cluster Autoscaler, ArgoCD structure). Superseded decisions stay in the repo with their status updated.
