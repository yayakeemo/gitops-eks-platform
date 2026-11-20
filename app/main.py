"""Tiny demo service used as the workload for the GitOps platform.

The app itself is intentionally boring. The point of this repo is the platform
around it: containers, CI/CD, Terraform, EKS and ArgoCD.
"""

import os

from flask import Flask, jsonify

app = Flask(__name__)

# Injected at build/deploy time (see Dockerfile and, later, the CI pipeline).
APP_VERSION = os.getenv("APP_VERSION", "dev")
APP_ENV = os.getenv("APP_ENV", "local")


@app.get("/")
def index():
    return jsonify(message="Hello from the GitOps demo service", env=APP_ENV)


@app.get("/healthz")
def healthz():
    """Liveness/readiness endpoint, used by Docker and later by Kubernetes probes."""
    return jsonify(status="ok")


@app.get("/version")
def version():
    return jsonify(version=APP_VERSION, env=APP_ENV)


if __name__ == "__main__":
    # Local development only. In the container we run gunicorn instead.
    app.run(host="127.0.0.1", port=int(os.getenv("PORT", "8080")))
