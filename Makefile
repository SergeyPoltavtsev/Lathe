help:  ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:  ## Install/refresh the venv from pyproject + uv.lock, and wire git hooks.
	uv sync
	uv run pre-commit install --hook-type pre-commit --hook-type pre-push

build:  ## Build wheel + sdist into dist/.
	uv build

##### Dev ######

test:  ## Run the full test suite (unit + integration).
	uv run pytest

unit-tests:  ## Run unit tests only.
	uv run pytest tests/unit

integration-tests:  ## Run integration tests only.
	uv run pytest tests/integration

lint-check:  ## Lint without writing.
	uv run ruff check

lint-fix:  ## Lint and auto-fix.
	uv run ruff check --fix

format-check:  ## Check formatting without writing.
	uv run ruff format --check

format-fix:  ## Format the code.
	uv run ruff format

type-check:
	uv run ty check

pre-commit:  ## Fast gate: format-check + lint-check + unit tests.
	$(MAKE) format-check
	$(MAKE) lint-check
	$(MAKE) unit-tests

ci:  ## What CI runs: lockfile check + format-check + lint-check + full tests.
	uv lock --check
	$(MAKE) format-check
	$(MAKE) lint-check
	$(MAKE) test

.PHONY: install test unit-tests integration-tests lint-check lint-fix format-check format-fix pre-commit eval-benchmark eval-regression-dataset eval-regression-suite kitaru-local kitaru-bootstrap kitaru-seed build install-cli uninstall-cli ci help
