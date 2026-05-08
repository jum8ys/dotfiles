# Jum8ys's dotfiles

Jum8ys's dotfiles repository, managed with [chezmoi](https://chezmoi.io/).

## Tools

| Tool | Description |
| --- | --- |
| [sheldon](https://sheldon.cli.rs/) | Zsh plugin manager |
| [zeno](https://github.com/yuki-yano/zeno.zsh) | Zsh snippet and fuzzy completion |

## Prerequisites

- [Homebrew](https://brew.sh/)

## Get started

### 1. Install chezmoi

```shell
brew install chezmoi
```

### 2. Initialize chezmoi with dotfiles repo

```shell
chezmoi init git@github.com:jum8ys/dotfiles.git
```

### 3. Copy `.chezmoidata.toml`

```shell
chezmoi cd
cp .chezmoidata.toml.example .chezmoidata.toml
```

Set variables to `.chezmoidata.toml`.

### 4. Check what changes

```shell
chezmoi diff
```

### 5. If you are happy with the changes that chezmoi will make then run

```shell
chezmoi apply -v
```

`-v`: verbose

### 6. Install base packages from the Brewfile

```shell
brew bundle --global
```

Note: `dot_Brewfile` only tracks the base CLI tools required by these dotfiles. Personal additions (casks, VS Code extensions, npm packages) live in your local `~/.Brewfile` and are not synced back to the source.

## How to Edit

### 1. Edit the target file directly

```shell
vim ~/.bashrc
```

### 2. Re-add the changes to the source state

```shell
chezmoi re-add
```

### 3. See what changes have been captured

```shell
chezmoi cd
git diff
```

### 4. Commit your changes and git push

```shell
git add .
git commit -m "Commit message"
git push
```
