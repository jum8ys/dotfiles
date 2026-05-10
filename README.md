# Jum8ys's dotfiles

Jum8ys's dotfiles repository, managed with [chezmoi](https://chezmoi.io/).

## Tools

| Tool | Description |
| --- | --- |
| [sheldon](https://sheldon.cli.rs/) | Zsh plugin manager |
| [zeno](https://github.com/yuki-yano/zeno.zsh) | Zsh snippet and fuzzy completion |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |

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
3. Creating `dot_zshrc.local` from the example for machine-specific shell settings
4. Previewing and applying changes with `chezmoi apply`
5. Installing Homebrew packages with `brew bundle --global`

> **Note:** Files copied from `.example` are not tracked by git, as they may differ per machine. Customize them freely after copying.

> **Note:** `dot_Brewfile` only tracks the base CLI tools required by these dotfiles. Personal additions (casks, VS Code extensions, etc.) live in your local `~/.Brewfile` and are not synced back to the source.

## Machine-specific shell settings

`~/.zshrc.local` is sourced at the end of `~/.zshrc` and is not tracked by git.
Add environment-specific configuration here.

```zsh
# Examples:
# export JAVA_HOME=/usr/local/opt/openjdk
# alias work='cd ~/src/work'
```


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
