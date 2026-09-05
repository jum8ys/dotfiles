# Jum8ys's dotfiles

Jum8ys's dotfiles repository, managed with [chezmoi](https://chezmoi.io/).

## Tools

| Tool | Description |
| --- | --- |
| [sheldon](https://sheldon.cli.rs/) | Zsh plugin manager |
| [zeno](https://github.com/yuki-yano/zeno.zsh) | Zsh snippet and fuzzy completion |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |
| [worktrunk](https://github.com/max-sixty/worktrunk) | Git worktree manager |
| [nix-darwin](https://github.com/nix-darwin/nix-darwin) | Declarative macOS system settings |
| [home-manager](https://github.com/nix-community/home-manager) | Declarative user packages (`home.packages` only; dotfiles stay in chezmoi) |

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
4. Installing Homebrew packages with `brew bundle --global`, then starting the `borders` service
5. Bootstrapping [nix-darwin](#nix-darwin-macos-system-config) if Nix is installed

The following are optional and can be set up independently.

| Command | Description |
| --- | --- |
| `make local-claude-rules` | Machine-specific Claude Code rules |
| `make local-zshrc` | Machine-specific shell settings |

> **Note:** Files copied from `.example` are gitignored and may differ per machine. `dot_Brewfile` only tracks base CLI tools — personal additions live in your local `~/.Brewfile`.

## nix-darwin (macOS system config)

Source lives in `private_dot_config/nix-darwin/` (deploys to `~/.config/nix-darwin/`). The `.nix.tmpl` files are chezmoi templates — `chezmoi apply` fills in `{{ .chezmoi.username }}`, `{{ .chezmoi.hostname }}`, and `{{ .chezmoi.homeDir }}` with the current machine's values, so no personal identifiers are committed to the repo.

### Prerequisites

- Apple Silicon Mac (this flake hardcodes `system = "aarch64-darwin"`)
- [Nix](https://nixos.org/download) installed
- `chezmoi apply` has been run at least once, so `~/.config/nix-darwin/` exists

### First-time setup

`make install` runs this for you (step 5/5) if Nix is installed and `~/.config/nix-darwin/` exists. `/etc/nix/nix.conf` doesn't have flakes enabled yet on a fresh Nix install, so the first run needs the flag explicitly — it's harmless to keep on later runs too, so the same command works either way:

```shell
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix-darwin
```

> **Note:** nix-darwin aborts with `Unexpected files in /etc` if `/etc/bashrc` or `/etc/zshrc` is a plain file, so `make install` moves each to `<file>.before-nix-darwin` with `sudo` before switching.

### Making changes

Edit `darwin-configuration.nix.tmpl` (macOS system settings) or `nix/packages.nix` (`home.packages`), then:

```shell
make rebuild
```

`make rebuild` shows `chezmoi diff`, then asks about each step separately so either can be skipped:

```shell
chezmoi apply                                             # [1/2]
sudo darwin-rebuild switch --flake ~/.config/nix-darwin   # [2/2]
```

The steps are confirmed separately so a nix-darwin rebuild can run without redeploying every dotfile.

Files under `nix/` carry no chezmoi template syntax, so edit and commit them directly; `chezmoi apply` only copies them across. Machine-specific values stay in the `*.nix.tmpl` entry files.

> **Note:** `flake.lock` is tracked in chezmoi like any other file, so every machine builds the same pinned nixpkgs/nix-darwin/home-manager revisions. After running `nix flake update`, sync the change back with `chezmoi re-add`.

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
