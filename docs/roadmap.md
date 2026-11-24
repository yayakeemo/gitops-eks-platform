# Roadmap

About one hour a day, roughly 20 weeks. Each phase ends with something that works and something I can explain.

| Phase | Weeks | Deliverable | Done when |
|---|---|---|---|
| 1. Docker | 1-2 | Multi-stage, non-root image of the demo app, scanned with Trivy | ✅ Complete |
| 2. CI/CD | 3-4 | GitHub Actions: test, build, scan, push to a registry | ✅ Complete |
| 3. AWS + Terraform | 5-8 | VPC, IAM, ECR with remote state, all in Terraform | ✅ Complete |
| 4. Kubernetes basics | 9-12 | App running on kind with deployment, service, ingress, probes, limits, secrets | ✅ Complete |
| 5. EKS + ArgoCD | 13-16 | EKS via Terraform, ArgoCD app-of-apps, dev and prod environments from Git | A Git commit changes what runs in the cluster, with no manual `kubectl apply` |
| 6. Production hardening | 17-20 | external-secrets, Prometheus/Grafana, Karpenter, Kyverno, ADRs, diagram, cost notes, write-up | README architecture diagram, ADRs and a blog post published |

If time runs short, cut scope from phase 6, not the earlier phases.

## Phase 1 checklist

- [x] Run the app locally and the tests pass
- [x] Build the image and run it
- [x] Confirm it runs as a non-root user (`docker run --rm gitops-demo:dev id`)
- [x] Scan with Trivy and fix or document findings
- [x] Compare image size against a single-stage build and record it in the learning log
- [x] Write ADR 0002 notes (base image choice) in your own words

## Phase 2 checklist

- [x] Create GitHub Actions workflow that triggers on push to `main`
- [x] Workflow runs tests with `make test`
- [x] Workflow builds image with `make build`
- [x] Workflow scans image with Trivy (fails on CRITICAL, allows documented HIGH)
- [x] Workflow logs in to ghcr.io
- [x] Workflow tags image with `latest` and commit SHA
- [x] Workflow pushes both tags to registry
- [x] Verify image appears in ghcr.io packages
