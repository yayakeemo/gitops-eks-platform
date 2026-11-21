IMAGE ?= gitops-demo
VERSION ?= dev

.PHONY: install test run build run-container scan clean

install:
	python3 -m venv .venv && .venv/bin/pip install -r requirements-dev.txt

test:
	.venv/bin/python -m pytest -q

run:
	.venv/bin/python -m app.main

build:
	docker build --build-arg APP_VERSION=$(VERSION) -t $(IMAGE):$(VERSION) .

run-container:
	docker run --rm -p 8080:8080 $(IMAGE):$(VERSION)

# Requires Trivy: https://trivy.dev
# Note: HIGH vulnerabilities are documented and accepted in phase 1. Only fail on CRITICAL.
scan:
	trivy image --severity CRITICAL --exit-code 1 $(IMAGE):$(VERSION)

clean:
	rm -rf .venv .pytest_cache
