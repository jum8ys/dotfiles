# Machine-independent home-manager configuration.
#
# Why these modules live under private_dot_config/ instead of the repo root:
#   - Flake evaluation is pure, so every imported file must sit inside the flake
#     directory (~/.config/nix-darwin). A module kept in the chezmoi source repo
#     and imported by absolute path would break pure eval.
#   - Adding the chezmoi repo as a flake input is worse: a path:/git+file input
#     copies the working tree into the world-readable Nix store, which would leak
#     .chezmoidata.toml.
#   So these modules stay here and chezmoi copies them verbatim to
#   ~/.config/nix-darwin/nix/. They contain no chezmoi template syntax: edit and
#   commit them directly; `chezmoi apply` only re-copies them (see `make rebuild`).
#
# Machine-specific values (username, home dir, hostname) never appear here. They
# stay in the *.nix.tmpl entry files and reach these modules through
# home-manager's `config.home.username` / `config.home.homeDirectory`, or via
# module arguments passed from home.nix.
{ ... }:

{
  imports = [
    ./agent-skills.nix
    ./packages.nix
  ];
}
