# cli Specification

## Purpose
TBD - created by archiving change add-go-command. Update Purpose after archive.
## Requirements
### Requirement: Worktree Navigation Command
The wt tool SHALL provide a `go` subcommand that creates a worktree if missing and navigates to it.

#### Scenario: Worktree exists
- **WHEN** user runs `wt go <existing-worktree>`
- **THEN** tool changes directory to the existing worktree location
- **AND** no new worktree is created

#### Scenario: Worktree doesn't exist
- **WHEN** user runs `wt go <new-worktree>`
- **THEN** tool creates the worktree using the same logic as `add` command
- **AND** tool changes directory to the newly created worktree location
- **AND** setup script runs if present

#### Scenario: Invalid usage
- **WHEN** user runs `wt go` without arguments
- **THEN** tool displays usage message
- **AND** tool exits with error code

#### Scenario: Help and usage
- **WHEN** user runs `wt` without arguments
- **THEN** help message includes `go <name>` option
- **AND** usage describes combined add and navigate functionality

