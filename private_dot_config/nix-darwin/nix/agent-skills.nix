# herdr's agent skill for Claude Code (~/.claude) and Codex (~/.agents).
# Managed by home-manager, not chezmoi: the skill is generated (`herdr --skill`,
# written into the package by nixpkgs' postInstall), so linking the package copy
# tracks the installed herdr with no regenerate-and-commit step.
{ config, pkgs, ... }:

let
  # Codex discovers symlinked skill directories but ignores a symlinked SKILL.md.
  herdrSkillDir = "${pkgs.herdr}/share/herdr/skills/herdr";
in
{
  home.file.".agents/skills/herdr".source = herdrSkillDir;
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills";
}
