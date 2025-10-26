# wt - Git Worktree Management Tool

A simple bash script that provides a streamlined interface for managing git worktrees with automatic symlink management and optional setup script integration.

## 🚀 Quick Start

```bash
# Clone and setup
git clone <repository-with-wt>
cd <project>
chmod +x wt

# Create your first worktree
./wt add feature-authentication

# List all worktrees
./wt list

# Remove when done
./wt remove feature-authentication
```

## 📦 Installation

1. **Download the script** to your project root:
   ```bash
   curl -O https://raw.githubusercontent.com/your-repo/wt/main/wt
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
2. Removes the git worktree
3. Removes the symlink

### `./wt list`
Lists all existing worktrees in the repository.

```bash
./wt list
# Shows all worktrees with their paths and branches
```

## 🏗️ Directory Structure

After using `wt`, your project will look like this:

```
your-project/
├── wt                          # The management script
├── .wt/                        # Created on first use
│   ├── .gitignore              # Ignores worktrees directory
│   ├── setup                   # Optional setup script (template)
│   └── worktrees/              # Symlinks to actual worktrees
│       ├── feature-auth        # -> ~/tmp/your-project-feature-auth
│       ├── bugfix-123          # -> ~/tmp/your-project-bugfix-123
│       └── experimental        # -> ~/tmp/your-project-experimental
```

**Actual worktrees are stored in:**
```
~/tmp/
├── your-project-feature-auth/
├── your-project-bugfix-123/
└── your-project-experimental/
```

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
- **Automatic Execution**: Runs after every `wt add` operation
- **Template Creation**: `wt` creates a basic template on first use if none exists

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
# Fix the bug and create PR...
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

## ⚙️ Configuration

### Default Worktree Location
By default, worktrees are created in `~/tmp/`. You can modify this by editing the `TMP_DIR` variable in the `wt` script:

```bash
# Change this line in the wt script
TMP_DIR="${HOME}/tmp"  # Default
# TMP_DIR="${HOME}/workspaces"  # Custom location
```

### Custom Setup Script Template
The first time you run `./wt add`, it creates a template setup script. You can customize this for your project's needs.

## 🐛 Troubleshooting

### "Worktree already exists"
```bash
# Check existing worktrees
./wt list

# Remove the existing worktree first
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
# Remove the broken symlink manually
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

## 🤝 Contributing

This is a simple utility script. To contribute:

1. Fork the repository
2. Create a feature worktree: `./wt add your-feature`
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - feel free to use this in your projects.

## 🆘 Support

If you encounter issues:

1. Check that you're in a git repository
2. Ensure the script is executable
3. Verify git worktree support: `git worktree --version`
4. Check permissions on your `~/tmp/` directory

---

**Happy worktree managing! 🌳**