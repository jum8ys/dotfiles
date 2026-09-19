# direnv with nix-direnv (cached `use flake`, devShell protected from GC).
# Managed by home-manager, not chezmoi: nix-direnv's direnvrc points into the
# Nix store and its path changes on every update, so letting home-manager
# generate it avoids maintaining that path by hand.
{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # ~/.zshrc is owned by chezmoi, so the hook is added in dot_zshrc instead.
    enableZshIntegration = false;
  };
}
