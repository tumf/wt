# Makefile for wt - Git Worktree Management Tool

.PHONY: help bump-major bump-minor bump-patch bump-beta release install clean test

# Default target
help:
	@echo "wt - Git Worktree Management Tool"
	@echo ""
	@echo "Available targets:"
	@echo "  help        - Show this help message"
	@echo "  version     - Show current version"
	@echo "  bump-major  - Increment major version (X.0.0 -> X+1.0.0)"
	@echo "  bump-minor  - Increment minor version (X.Y.0 -> X.Y+1.0)"
	@echo "  bump-patch  - Increment patch version (X.Y.Z -> X.Y.Z+1)"
	@echo "  bump-beta   - Add beta suffix (X.Y.Z -> X.Y.Z-beta)"
	@echo "  release     - Remove beta suffix for release (X.Y.Z-beta -> X.Y.Z)"
	@echo "  install      - Install wt script to /usr/local/bin"
	@echo "  clean       - Remove temporary files and artifacts"
	@echo "  test        - Run basic tests"

# Version management
version:
	@./wt --version

# Extract current version components
CURRENT_MAJOR := $(shell ./wt --version | sed 's/wt version //' | cut -d. -f1)
CURRENT_MINOR := $(shell ./wt --version | sed 's/wt version //' | cut -d. -f2)
CURRENT_PATCH := $(shell ./wt --version | sed 's/wt version //' | cut -d. -f3 | cut -d- -f1)

# Version bumping targets
bump-major:
	@echo "Bumping major version: $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH) -> $$(( $(CURRENT_MAJOR) + 1 )).0.0"
	@sed -i.bak 's/^WT_VERSION=".*"/WT_VERSION="$$(( $(CURRENT_MAJOR) + 1 )).0.0"/' wt
	@rm -f wt.bak
	@./wt --version

bump-minor:
	@echo "Bumping minor version: $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH) -> $(CURRENT_MAJOR).$$(( $(CURRENT_MINOR) + 1 )).0"
	@sed -i.bak 's/^WT_VERSION=".*"/WT_VERSION="$(CURRENT_MAJOR).$$(( $(CURRENT_MINOR) + 1 )).0"/' wt
	@rm -f wt.bak
	@./wt --version

bump-patch:
	@echo "Bumping patch version: $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH) -> $(CURRENT_MAJOR).$(CURRENT_MINOR).$$(( $(CURRENT_PATCH) + 1 ))"
	@sed -i.bak 's/^WT_VERSION=".*"/WT_VERSION="$(CURRENT_MAJOR).$(CURRENT_MINOR).$$(( $(CURRENT_PATCH) + 1 ))"/' wt
	@rm -f wt.bak
	@./wt --version

bump-beta:
	@echo "Adding beta suffix: $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH) -> $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH)-beta"
	@sed -i.bak 's/^WT_VERSION=".*"/WT_VERSION="$(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH)-beta"/' wt
	@rm -f wt.bak
	@./wt --version

release:
	@./wt --version | grep -q "beta" && \
		(echo "Removing beta suffix: $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH)-beta -> $(CURRENT_MAJOR).$(CURRENT_MINOR).$(shell echo $(CURRENT_PATCH) | cut -d- -f1)"; \
		sed -i.bak 's/^WT_VERSION=".*"/WT_VERSION="$(CURRENT_MAJOR).$(CURRENT_MINOR).$(shell echo $(CURRENT_PATCH) | cut -d- -f1)"/' wt; \
		rm -f wt.bak; \
		./wt --version) || \
		echo "Current version $(CURRENT_MAJOR).$(CURRENT_MINOR).$(CURRENT_PATCH) is not a beta version"

# Installation
install:
	@echo "Installing wt to /usr/local/bin..."
	@sudo cp wt /usr/local/bin/wt
	@echo "Installation complete. Use 'wt' from anywhere."

# Development tasks
clean:
	@echo "Cleaning temporary files..."
	@rm -f wt.bak
	@rm -rf .wt/
	@echo "Clean complete."

test:
	@echo "Running basic tests..."
	@echo "Testing version command..."
	@./wt --version
	@echo "Testing help message..."
	@./wt || true
	@echo "Basic tests passed."