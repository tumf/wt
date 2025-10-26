<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a git worktree management tool called `wt` - a shell script that provides a simplified interface for managing git worktrees. The tool allows users to create, remove, and list worktrees with automatic symlinks and optional setup scripts.

## Commands

### Basic Usage
- `./wt add <name>` - Create a new worktree for branch `<name>` (creates branch if it doesn't exist)
- `./wt remove <name>` - Remove a worktree and its symlink
- `./wt list` - List all existing worktrees

### Development Commands
- `chmod +x wt` - Make the script executable (needed after cloning)
- `bash wt` or `./wt` - Run the worktree management script

## Architecture

### Core Components

**wt (main script)**: A bash script that provides three main operations:
- **add**: Creates new git worktrees in `~/tmp/<project>-<name>` with symlinks in `.wt/worktrees/`
- **remove**: Safely removes worktrees and cleans up symlinks
- **list**: Displays all current worktrees

### Directory Structure
```
project/
├── wt                 # Main worktree management script
└── .wt/              # Created on first use
    ├── .gitignore     # Ignores worktrees directory
    ├── setup          # Optional setup script template
    └── worktrees/     # Contains symlinks to actual worktrees
```

### Worktree Locations
- **Actual worktrees**: `~/tmp/<current-dir-name>-<branch-name>`
- **Symlinks**: `.wt/worktrees/<branch-name>` → `~/tmp/<current-dir-name>-<branch-name>`

### Setup System
The tool supports an optional `.wt/setup` script that runs after worktree creation:
- Template created automatically on first `add` operation
- Receives `$ROOT_WORKTREE_PATH` environment variable
- Useful for initializing project-specific dependencies or configurations

## Key Features

- **Automatic branch creation**: Creates new branches if they don't exist
- **Symlink management**: Maintains organized symlinks in project directory
- **Setup script integration**: Runs project-specific setup after worktree creation
- **Error handling**: Prevents duplicate worktrees and handles cleanup properly
- **Portable**: Works with any git repository that uses this tool

## Usage Pattern

This tool is designed for projects that frequently need isolated worktrees for:
- Feature development
- Bug fixes
- Experimental changes
- Parallel development streams

The worktrees are created outside the main project directory to keep the workspace clean while maintaining easy access through symlinks.