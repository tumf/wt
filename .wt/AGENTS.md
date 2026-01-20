# .wt Directory

## Overview

The `.wt` directory is the configuration and state directory for the **wt** (worktree) tool, a git worktree management system. This directory contains setup scripts, symlinks to worktrees, and local configuration files.

## Purpose

The `wt` tool simplifies git worktree management by:
- Creating organized worktrees in a centralized location (`~/.wt/worktrees`)
- Maintaining symlinks in `.wt/worktrees/` for easy access
- Running setup scripts automatically when worktrees are created
- Supporting custom per-worktree and per-project configurations

## Directory Structure

```
.wt/
├── AGENTS.md          # This file - documentation for AI agents
├── .gitignore         # Git ignore rules for this directory
├── setup              # Setup script template (executed in new worktrees)
├── setup.local        # Local setup overrides (gitignored)
└── worktrees/         # Symlinks to actual worktrees (gitignored)
    ├── feature-a -> ~/.wt/worktrees/project-name-feature-a
    ├── bugfix-b -> ~/.wt/worktrees/project-name-bugfix-b
    └── ...
```

## Files

### `.gitignore`

Prevents committing:
- `worktrees/` - Symlinks to worktrees (machine-specific)
- `*.local` - Local configuration files (user-specific)

### `setup`

Template setup script that runs when a new worktree is created. This script:
- Receives `$ROOT_WORKTREE_PATH` environment variable pointing to the base repository
- Can be customized per-project
- Sources `setup.local` if it exists for user-specific overrides

Common use cases:
- Installing dependencies (`npm install`, `bundle install`, etc.)
- Setting up development environment
- Creating configuration files
- Running initial builds

### `setup.local`

User-specific setup overrides (not committed to git). Create this file to add:
- Local environment variables
- User-specific development tools
- Machine-specific configuration

## How wt Uses This Directory

1. **Initialization**: When you run `wt add/go/run` for the first time, the directory structure is created automatically
2. **Worktree Creation**: New worktrees are created in `~/.wt/worktrees/{project-name}-{branch-name}`
3. **Symlink Creation**: A symlink is created in `.wt/worktrees/{branch-name}` pointing to the actual worktree
4. **Setup Execution**: The `setup` script runs in the context of the new worktree with `$ROOT_WORKTREE_PATH` set

## Best Practices

### For Project Maintainers

1. **Customize setup script**: Edit `.wt/setup` to include project-specific initialization
2. **Document requirements**: Add comments in `setup` explaining what happens
3. **Keep it fast**: Setup runs on every new worktree, so optimize for speed
4. **Make it idempotent**: Ensure setup can run multiple times safely

### For Contributors

1. **Create setup.local**: Add your personal setup steps without modifying the committed `setup` file
2. **Don't commit worktrees directory**: It's already gitignored
3. **Use relative paths**: When possible, use `$ROOT_WORKTREE_PATH` for paths to the main repository

## Example setup Script

```bash
#!/bin/bash
# wt - Git Worktree Management Tool
# https://github.com/tumf/wt
# $ROOT_WORKTREE_PATH is path to the base repository (source tree)

# Source local overrides first
if [ -f .wt/setup.local ]; then
  source .wt/setup.local
fi

# Install dependencies (use cache from root if available)
if [ -d "$ROOT_WORKTREE_PATH/node_modules" ]; then
  echo "Linking node_modules from root worktree..."
  ln -sf "$ROOT_WORKTREE_PATH/node_modules" .
else
  echo "Installing dependencies..."
  npm install
fi

# Copy environment file if it doesn't exist
if [ ! -f .env ] && [ -f "$ROOT_WORKTREE_PATH/.env" ]; then
  cp "$ROOT_WORKTREE_PATH/.env" .env
fi

# Run initial build
npm run build
```

## Example setup.local

```bash
#!/bin/bash
# User-specific setup (not committed)

# Set custom environment variables
export DEBUG=true
export LOG_LEVEL=verbose

# Use custom package manager
alias npm='pnpm'

# Skip builds for faster setup
export SKIP_BUILD=true
```

## Integration with AI Agents

When working with this project, AI agents should:

1. **Respect the structure**: Don't modify `.wt/worktrees/` manually
2. **Update setup thoughtfully**: Changes to `setup` affect all new worktrees
3. **Suggest setup.local**: For user-specific customizations
4. **Use wt commands**: Prefer `wt add/go/run` over manual worktree commands
5. **Document changes**: Update this file if adding new conventions

## Related Documentation

- Main tool: `/wt` (bash script)
- Repository: https://github.com/tumf/wt
- Git worktrees: https://git-scm.com/docs/git-worktree
