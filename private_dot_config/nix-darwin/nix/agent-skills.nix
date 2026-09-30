# herdr's agent skill for Claude Code (~/.claude) and Codex (~/.agents).
# Managed by home-manager, not chezmoi: linking the skill installed by nixpkgs'
# installAgentSkills hook tracks herdr without committing generated output.
{ config, pkgs, ... }:

let
  # Codex discovers symlinked skill directories but ignores a symlinked SKILL.md.
  herdrSkillDir = "${pkgs.herdr}/share/skills/herdr/herdr";
in
{
  home.file.".agents/skills/herdr".source = herdrSkillDir;
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills";
}
