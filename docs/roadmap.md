# Roadmap

About one hour a day, roughly 20 weeks. Each phase ends with something that works and something I can explain.

| Phase | Weeks | Deliverable | Done when |
|---|---|---|---|
| 1. Docker | 1-2 | Multi-stage, non-root image of the demo app, scanned with Trivy | `make build && make scan` passes and the container serves `/healthz` |
| 2. CI/CD | 3-4 | GitHub Actions: test, build, scan, push to a registry | A push to `main` produces a tagged, scanned image |
| 3. AWS + Terraform | 5-8 | VPC, IAM, ECR with remote state, all in Terraform | `terraform apply` and `destroy` both work from a clean checkout; budget alert set |
| 4. Kubernetes basics | 9-12 | App running on kind with deployment, service, ingress, probes, limits, secrets | Rolling update and rollback demonstrated locally |
| 5. EKS + ArgoCD | 13-16 | EKS via Terraform, ArgoCD app-of-apps, dev and prod environments from Git | A Git commit changes what runs in the cluster, with no manual `kubectl apply` |
| 6. Production hardening | 17-20 | external-secrets, Prometheus/Grafana, Karpenter, Kyverno, ADRs, diagram, cost notes, write-up | README architecture diagram, ADRs and a blog post published |

If time runs short, cut scope from phase 6, not the earlier phases.

## Phase 1 checklist

- [ ] Run the app locally and the tests pass
- [ ] Build the image and run it
- [ ] Confirm it runs as a non-root user (`docker run --rm gitops-demo:dev id`)
- [ ] Scan with Trivy and fix or document findings
- [ ] Compare image size against a single-stage build and record it in the learning log
- [ ] Write ADR 0002 notes (base image choice) in your own words
