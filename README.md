# Jum8ys's dotfiles

Jum8ys's dotfiles repository, managed with [chezmoi](https://chezmoi.io/).

## Tools

| Tool | Description |
| --- | --- |
| [sheldon](https://sheldon.cli.rs/) | Zsh plugin manager |
| [zeno](https://github.com/yuki-yano/zeno.zsh) | Zsh snippet and fuzzy completion |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |
| [worktrunk](https://github.com/max-sixty/worktrunk) | Git worktree manager |

## Prerequisites

- [Homebrew](https://brew.sh/)

## Get started

### 1. Install chezmoi

```shell
brew install chezmoi
```

### 2. Initialize chezmoi with this repo

```shell
chezmoi init git@github.com:jum8ys/dotfiles.git
```

### 3. Run the interactive setup

```shell
cd ~/.local/share/chezmoi
make install
```

The setup walks you through these steps.

1. Creating `.chezmoidata.toml` from the example and opening it in your editor
2. Creating `dot_claude/settings.json` from the example for machine-specific Claude Code settings
3. Previewing and applying changes with `chezmoi apply`
4. Installing Homebrew packages with `brew bundle --global`

The following are optional and can be set up independently.

| Command | Description |
| --- | --- |
| `make local-claude-rules` | Machine-specific Claude Code rules |
| `make local-zshrc` | Machine-specific shell settings |

> **Note:** Files copied from `.example` are gitignored and may differ per machine. `dot_Brewfile` only tracks base CLI tools — personal additions live in your local `~/.Brewfile`.

## How to edit dotfiles

### Edit the deployed file directly

```shell
vim ~/.zshrc
chezmoi re-add   # sync changes back to source
```

### Edit via chezmoi

```shell
chezmoi edit ~/.zshrc   # opens source file in $EDITOR
chezmoi apply           # deploy changes to ~
```

### Commit and push

```shell
cd ~/.local/share/chezmoi
git add <files>
git commit -m "..."
git push
```
