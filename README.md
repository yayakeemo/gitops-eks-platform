# gitops-eks-platform

A production-style Kubernetes platform on AWS, built step by step: containers, CI/CD, Terraform, EKS and GitOps with ArgoCD.

> **Status:** Phase 1 of 6 (Docker). See the [roadmap](docs/roadmap.md) for where this is going.

## Why this exists

I'm a cloud architect with a background in OCI and Azure. I'm building this to get hands-on with the AWS and Kubernetes stack I design around, and to document the decisions along the way. The demo app is deliberately trivial. The platform around it is the point.

## Target architecture

_To be added in phase 5 (EKS + ArgoCD). Planned components:_

- AWS: VPC, EKS, ECR, IAM (Pod Identity), Secrets Manager
- Infrastructure as code: Terraform with remote state
- CI: GitHub Actions (test, build, scan, push)
- CD: ArgoCD with app-of-apps, separate dev and prod environments
- Platform extras: external-secrets, Prometheus and Grafana, Karpenter, Kyverno

## Progress

| Phase | Topic | Status |
|---|---|---|
| 1 | Docker: multi-stage build, non-root user, image scanning | In progress |
| 2 | CI/CD with GitHub Actions | Not started |
| 3 | AWS + Terraform | Not started |
| 4 | Kubernetes basics on kind | Not started |
| 5 | EKS + ArgoCD | Not started |
| 6 | Production hardening, ADRs, cost notes | Not started |

## Repo layout

```
app/             Demo Flask service (/, /healthz, /version)
tests/           Unit tests
Dockerfile       Multi-stage, non-root image
docs/            Roadmap, learning log, architecture decision records (ADRs)
terraform/       (phase 3+) Infrastructure as code
k8s/             (phase 4+) Kubernetes manifests / Helm charts
.github/         (phase 2+) CI workflows
```

## Quick start

Requires Python 3.13 and Docker.

```bash
make install          # create a virtualenv and install dependencies
make test             # run unit tests
make build            # build the container image
make run-container    # run it on http://localhost:8080
curl localhost:8080/healthz
make scan             # scan the image with Trivy (HIGH and CRITICAL fail the build)
```

## Design decisions

Decisions and trade-offs are recorded as ADRs in [docs/adr](docs/adr). A running log of what I learned and what broke is in [docs/learning-log.md](docs/learning-log.md).

## Cost

Phases 1 to 4 cost almost nothing. EKS adds about $73/month for the control plane plus nodes, so the cluster is built entirely from Terraform and destroyed after each working session.

## License

MIT
