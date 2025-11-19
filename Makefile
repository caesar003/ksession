# KSession Makefile
# Simplified build and deployment automation

SHELL := /bin/bash
SCRIPT_NAME := ksession
BUILD_SCRIPT := ./build.sh

# Get current version from VERSION file
CURRENT_VERSION := $(shell cat VERSION 2>/dev/null || echo "0.0.0")
PACKAGE_NAME := $(SCRIPT_NAME)-$(CURRENT_VERSION)-amd64.deb

# Default target
.PHONY: help
help: ## Show this help message
	@echo "KSession Build System"
	@echo "Current version: $(CURRENT_VERSION)"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: check
check: ## Check version consistency across all files
	@$(BUILD_SCRIPT) --check

.PHONY: build
build: ## Build package with current version
	@$(BUILD_SCRIPT) --build

.PHONY: version
version: ## Update version and build (usage: make version VERSION=1.4.1)
ifndef VERSION
	@echo "Error: VERSION parameter required"
	@echo "Usage: make version VERSION=1.4.1"
	@exit 1
endif
	@$(BUILD_SCRIPT) --version $(VERSION)

.PHONY: patch
patch: ## Increment patch version and build (1.4.0 -> 1.4.1)
	@$(eval NEW_VERSION := $(shell echo $(CURRENT_VERSION) | awk -F. '{$$3 = $$3 + 1} 1' OFS=.))
	@echo "Incrementing patch version: $(CURRENT_VERSION) -> $(NEW_VERSION)"
	@$(BUILD_SCRIPT) --version $(NEW_VERSION)

.PHONY: minor
minor: ## Increment minor version and build (1.4.0 -> 1.5.0)
	@$(eval NEW_VERSION := $(shell echo $(CURRENT_VERSION) | awk -F. '{$$2 = $$2 + 1; $$3 = 0} 1' OFS=.))
	@echo "Incrementing minor version: $(CURRENT_VERSION) -> $(NEW_VERSION)"
	@$(BUILD_SCRIPT) --version $(NEW_VERSION)

.PHONY: major
major: ## Increment major version and build (1.4.0 -> 2.0.0)
	@$(eval NEW_VERSION := $(shell echo $(CURRENT_VERSION) | awk -F. '{$$1 = $$1 + 1; $$2 = 0; $$3 = 0} 1' OFS=.))
	@echo "Incrementing major version: $(CURRENT_VERSION) -> $(NEW_VERSION)"
	@$(BUILD_SCRIPT) --version $(NEW_VERSION)

.PHONY: install
install: ## Install the built package using dpkg
	@if [ ! -f "dist/$(CURRENT_VERSION)/$(PACKAGE_NAME)" ]; then \
		echo "Package not found. Building first..."; \
		$(MAKE) build; \
	fi
	@echo "Installing $(PACKAGE_NAME)..."
	@sudo dpkg -i dist/$(CURRENT_VERSION)/$(PACKAGE_NAME)

.PHONY: uninstall
uninstall: ## Uninstall the package
	@sudo dpkg -r $(SCRIPT_NAME)

.PHONY: clean
clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf dist/
	@echo "Cleaned dist/ directory"

.PHONY: test
test: ## Run basic tests on the script
	@echo "Running basic tests..."
	@bash -n bin/$(SCRIPT_NAME) && echo "✓ Syntax check passed"
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck bin/$(SCRIPT_NAME) && echo "✓ ShellCheck passed"; \
	else \
		echo "⚠ ShellCheck not available, skipping"; \
	fi

.PHONY: info
info: ## Show current project information
	@echo "Project Information:"
	@echo "  Name: $(SCRIPT_NAME)"
	@echo "  Current Version: $(CURRENT_VERSION)"
	@echo "  Package Name: $(PACKAGE_NAME)"
	@echo "  Package Path: dist/$(CURRENT_VERSION)/$(PACKAGE_NAME)"
	@echo "  Package Exists: $(shell [ -f dist/$(CURRENT_VERSION)/$(PACKAGE_NAME) ] && echo "Yes" || echo "No")"

.PHONY: changelog
changelog: ## Generate a changelog entry (requires notes/ directory)
	@if [ ! -d "notes" ]; then mkdir -p notes; fi
	@echo "Generating changelog entry for version $(CURRENT_VERSION)..."
	@git log --oneline --since="$(shell git log --format=%ci -n 1 HEAD~1)" --format="- %s" > notes/changelog-$(CURRENT_VERSION).txt
	@echo "Changelog saved to notes/changelog-$(CURRENT_VERSION).txt"

# Quick shortcuts
.PHONY: b c i
b: build ## Quick alias for build
c: check ## Quick alias for check  
i: install ## Quick alias for install
