# wt - Git Worktree Management Tool

A simple bash script that provides a streamlined interface for managing git worktrees with automatic symlink management, optional setup script integration, and semantic versioning.

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://github.com/tumf/wt.git
cd wt
chmod +x wt

# Create your first worktree
./wt add feature-authentication

# List all worktrees
./wt list

# Remove when done
./wt remove feature-authentication
```

### `./wt go <name>`
Creates a worktree if needed and navigates to it.

```bash
./wt go feature-login
# Creates worktree if missing, then provides navigation guidance
```

## 📦 Installation

1. **Download script** to your project root:
   ```bash
   curl -O https://raw.githubusercontent.com/tumf/wt/main/wt
   chmod +x wt
   ```

2. **Or copy** the `wt` file to your existing git repository

3. **Make it executable**:
   ```bash
   chmod +x wt
   ```

## 🎯 Why Use wt?

Managing git worktrees manually can be cumbersome. `wt` simplifies this by:

- **🗂️ Organization**: Creates worktrees in a consistent location (`~/tmp/`)
- **🔗 Symlinks**: Provides easy access through project-local symlinks
- **⚡ Automation**: Handles branch creation and cleanup automatically
- **🛠️ Setup Integration**: Runs project-specific setup scripts
- **🚫 Safety**: Prevents duplicate worktrees and handles errors gracefully
- **🔧 Version Management**: Semantic versioning with Makefile

## 📋 Commands

### `./wt add <name>`
Creates a new worktree for the specified branch name.

```bash
./wt add feature-login
# Creates new branch 'feature-login' and worktree at ~/tmp/project-feature-login
# Creates symlink .wt/worktrees/feature-login -> ~/tmp/project-feature-login
```

**What happens:**
1. Checks if branch exists - creates it if not
2. Creates worktree at `~/tmp/<project>-<name>`
3. Creates symlink at `.wt/worktrees/<name>`
4. Runs optional setup script if `.wt/setup` exists

### `./wt remove <name>`
Safely removes a worktree and its symlink.

```bash
./wt remove feature-login
# Removes worktree and cleans up symlink
```

**What happens:**
1. Finds the actual worktree path from the symlink
2. Removes git worktree
3. Removes the symlink

### `./wt list`
Lists all existing worktrees in the repository.

```bash
./wt list
# Shows all worktrees with their paths and branches
```

### `./wt go <name>`
Creates a worktree if needed and navigates to it.

```bash
./wt go feature-login
# Creates worktree if missing, then provides navigation guidance
```

**What happens:**
1. Checks if worktree exists - creates it using `add` logic if missing
2. Provides navigation guidance to worktree directory
3. Runs setup script if creating new worktree

### `./wt version`
Shows the current version of wt.

```bash
./wt --version
# wt version 1.0.0
```

## 🏗️ Directory Structure

After using `wt`, your project will look like this:

```
your-project/
├── wt                          # The management script
├── Makefile                    # Version management and development tasks
├── README.md                    # This documentation
└── .wt/                        # Created on first use
    ├── .gitignore              # Ignores worktrees directory
    ├── setup                   # Optional setup script (template)
    └── worktrees/              # Symlinks to actual worktrees
        ├── feature-auth        # -> ~/tmp/your-project-feature-auth
        ├── bugfix-123          # -> ~/tmp/your-project-bugfix-123
        └── experimental        # -> ~/tmp/your-project-experimental
```

**Actual worktrees are stored in:**
```
~/tmp/
├── your-project-feature-auth/
├── your-project-bugfix-123/
└── your-project-experimental/
```

## 🔧 Version Management

`wt` includes a Makefile for semantic versioning and project management.

### Version Commands

```bash
# Show current version
make version
./wt --version

# Bump versions
make bump-patch    # 1.0.0 -> 1.0.1
make bump-minor    # 1.0.1 -> 1.1.0
make bump-major    # 1.1.0 -> 2.0.0
make bump-beta     # 1.1.0 -> 1.1.0-beta
make release       # 1.1.0-beta -> 1.1.0
```

### Development Commands

```bash
# Run tests
make test

# Clean temporary files
make clean

# Install system-wide
make install
```

### Available Targets

- `help` - Show available make targets
- `version` - Display current version
- `bump-major` - Increment major version
- `bump-minor` - Increment minor version
- `bump-patch` - Increment patch version
- `bump-beta` - Add beta suffix
- `release` - Remove beta suffix for release
- `install` - Install to /usr/local/bin
- `clean` - Remove temporary files
- `test` - Run basic tests

## 🔧 Setup Script Integration

`wt` supports automatic setup scripts that run after creating a worktree.

### Creating a Setup Script

1. Create `.wt/setup` in your project root:
   ```bash
   #!/bin/bash
   # $ROOT_WORKTREE_PATH contains the path to the new worktree

   echo "Setting up worktree at: $ROOT_WORKTREE_PATH"

   # Install dependencies
   cd "$ROOT_WORKTREE_PATH"
   npm install

   # Copy configuration files
   cp .env.example .env.local

   echo "Setup complete!"
   ```

2. Make it executable:
   ```bash
   chmod +x .wt/setup
   ```

### Setup Script Features

- **Environment Variable**: `$ROOT_WORKTREE_PATH` points to the new worktree
- **Automatic Execution**: Runs after every `wt add` or `wt go` (when creating new worktree)
- **Template Creation**: `wt` creates a basic template on first use if none exists
- **Flexible**: Customize for your project's specific needs

## 🎨 Use Cases

### Feature Development
```bash
# Start working on a new feature
./wt add user-profile-page
cd .wt/worktrees/user-profile-page
# Develop your feature...
```

### Bug Fixes
```bash
# Quick bug fix worktree
./wt add fix-login-bug
cd .wt/worktrees/fix-login-bug
# Fix bug and create PR...
```

### Experimental Changes
```bash
# Try something risky
./wt add experimental-refactor
cd .wt/worktrees/experimental-refactor
# Experiment safely...
./wt remove experimental-refactor  # Clean up when done
```

### Parallel Development
```bash
# Work on multiple features simultaneously
./wt add feature-auth
./wt add feature-dashboard
./wt add bugfix-navigation

# List all your worktrees
./wt list

# Switch between contexts
cd .wt/worktrees/feature-auth      # Work on auth
cd .wt/worktrees/feature-dashboard # Work on dashboard
```

### Version Management Workflow
```bash
# Start new feature development
make bump-minor    # 1.0.0 -> 1.1.0
./wt add new-api-feature

# Prepare for release
make release         # Remove beta suffix for stable release
git tag v1.1.0
git push origin v1.1.0

# Patch release
make bump-patch      # 1.1.0 -> 1.1.1
./wt add hotfix-123
```

## ⚙️ Configuration

### Default Worktree Location
By default, worktrees are created in `~/tmp/`. You can modify this by editing the `TMP_DIR` variable in the `wt` script:

```bash
# Change this line in the wt script
TMP_DIR="${HOME}/workspaces"  # Custom location
```

### Custom Setup Script Template
The first time you run `./wt add`, it creates a template setup script. You can customize this for your project's needs.

## 🐛 Troubleshooting

### "Worktree already exists"
```bash
# Check existing worktrees
./wt list

# Remove existing worktree first
./wt remove <name>
# Then add again
./wt add <name>
```

### "Permission denied"
```bash
# Make sure the script is executable
chmod +x wt
```

### "Symlink already exists"
```bash
# Remove broken symlink manually
rm .wt/worktrees/<name>
# Then try adding again
./wt add <name>
```

### Clean up after system crash
```bash
# Remove all wt-managed worktrees
rm -rf .wt/
git worktree prune
```

## 🔒 Security

The `wt` script:
- Only creates worktrees in your home directory
- Uses relative paths for symlinks
- Doesn't require elevated permissions
- Works with standard git worktree commands
- Follows shell script security best practices

## 🤝 Contributing

This is a simple utility script with semantic versioning. To contribute:

1. Fork repository: https://github.com/tumf/wt
2. Clone locally: `git clone https://github.com/yourusername/wt.git`
3. Create a feature worktree: `./wt add your-feature`
4. Make your changes
5. Test thoroughly
6. Submit a pull request

### Development Workflow

```bash
# Use version management
make bump-minor    # Start new feature
./wt add new-feature
make test           # Run tests
make clean           # Clean up artifacts

# Prepare release
make release         # Remove beta suffix
git tag v$(make version)
git push origin v$(make version)
```

## 📄 License

MIT License - feel free to use this in your projects.

## 🆘 Support

If you encounter issues:

1. Check that you're in a git repository
2. Ensure script is executable
3. Verify git worktree support: `git worktree --version`
4. Check permissions on your `~/tmp/` directory
5. Check Makefile targets: `make help`

---

**Happy worktree managing! 🌳**