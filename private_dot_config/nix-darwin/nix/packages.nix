# User-level packages installed through home-manager.
#
# Scope is CLI tools that exist in nixpkgs. Three neighbouring things stay out
# on purpose:
#   - macOS system settings (system.defaults) and Homebrew formulae/casks are
#     system-level, so they belong in darwin-configuration.nix.tmpl.
#   - GUI apps, casks, and anything missing from nixpkgs stay in Homebrew.
#   - Dotfiles stay in chezmoi. Several tools here rewrite their own config
#     file (Claude Code, Zed, Karabiner), and `chezmoi re-add` pulls those
#     edits back into source; home-manager has no equivalent short of an
#     activation script plus drift detection.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tirith
  ];
}
