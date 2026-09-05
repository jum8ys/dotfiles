# herdr's agent skill for Claude Code (~/.claude) and Codex (~/.agents).
# Managed by home-manager, not chezmoi: the file is generated (`herdr --skill`,
# written into the package by nixpkgs' postInstall), so linking the package copy
# tracks the installed herdr with no regenerate-and-commit step.
{ pkgs, ... }:

let
  herdrSkill = "${pkgs.herdr}/share/herdr/skills/herdr/SKILL.md";
in
{
  home.file.".claude/skills/herdr/SKILL.md".source = herdrSkill;
  home.file.".agents/skills/herdr/SKILL.md".source = herdrSkill;
}
