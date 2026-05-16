# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a [chezmoi](https://chezmoi.io/) dotfiles repository. Chezmoi manages dotfiles by maintaining a **source state** (this repo) and applying it to the **target state** (`~`). Reference: [command overview](https://www.chezmoi.io/user-guide/command-overview/), [reference](https://www.chezmoi.io/reference/).

> **Important:** Files in this repo are *sources*, not standalone configs. Editing a file here changes what its target under `~` will become on the next `chezmoi apply`. Many files deploy as **user-global** environment (shell, git, ssh, Claude Code, etc.), so edits affect every project, not only this repository.
>
> To check what a source file will become, use `chezmoi cat <target-path>` or `chezmoi diff` rather than guessing from the filename.

## Two `CLAUDE.md` files in this repo

This repository contains two `CLAUDE.md` files with **different roles** — do not conflate them:

- The **root** `CLAUDE.md` (this file): guidance for Claude when working **inside this chezmoi repository**. Not deployed to `~`.
- A second `CLAUDE.md` under `dot_claude/`: the **source** of `~/.claude/CLAUDE.md`, i.e. user-global Claude Code rules that apply across every project.

The source under `dot_claude/` and the deployed `~/.claude/CLAUDE.md` are not duplicates — one is the chezmoi source, the other is the rendered copy. Edit the source and run `chezmoi apply`; if the deployed copy was edited directly, run `chezmoi re-add` to bring the change back into source.

## Common Commands

```shell
chezmoi diff                  # Preview changes before applying
chezmoi apply -v              # Apply source state to ~ (verbose)
chezmoi status                # Show pending changes summary
chezmoi re-add                # Pull edits made directly in ~ back into source
chezmoi add ~/.foo            # Import a new file from ~ into source
chezmoi edit ~/.foo           # Edit the source version of a file
chezmoi cat ~/.foo            # Print the rendered output without applying
chezmoi data                  # Show all available template variables as JSON
chezmoi execute-template      # Test/debug template syntax interactively
chezmoi doctor                # Diagnose common issues
chezmoi cd                    # Open a subshell in the source directory
brew bundle --global          # Install/sync Homebrew packages from dot_Brewfile
```

The typical edit workflow is: edit the **source file** in this repository directly, then run `chezmoi apply` to deploy the change to `~`. Never edit the deployed files under `~` directly.

## Source State Attributes

Chezmoi encodes metadata in filenames:

| Attribute | Meaning |
| --- | --- |
| `dot_` prefix | Deployed with a leading `.` (e.g. `dot_zshrc` → `~/.zshrc`) |
| `private_dot_` prefix | Same as `dot_`, but permissions set to 0600/0700 |
| `executable_` prefix | Deployed as executable (`chmod +x`) |
| `.tmpl` suffix | Processed as a Go template before writing |

Full reference: <https://www.chezmoi.io/reference/source-state-attributes/>

## Template Variables

`.tmpl` files use Go template syntax (`{{ .variable }}`). Variables come from:

1. **`.chezmoidata.toml`** — personal data file, gitignored. Copy from `.chezmoidata.toml.example` and fill in values before running `chezmoi apply`.
2. **Built-in chezmoi variables** — e.g. `{{ .chezmoi.os }}`, `{{ .chezmoi.hostname }}`. Run `chezmoi data` to see all available values.

## Special Files

- `.chezmoidata.toml` — template data; gitignored
- `.chezmoidata.toml.example` — shows required keys; committed to git
- `.chezmoiignore` — files excluded from deployment to `~`
- `.chezmoiversion` — minimum required chezmoi version
