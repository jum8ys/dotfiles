#!/usr/bin/env bash
# PreToolUse hook for Bash: deny the first attempt of every `git commit` and hand
# back the "## Git" and "## Interaction" sections of ~/.claude/CLAUDE.md (the
# latter holds the approval-before-committing rule) so the rules are fresh when
# the message is written. Re-running the same command passes untouched.
# This is a reminder, not a validator: the retry is never checked.

set -Eeuo pipefail
# Exit code 2 is a blocking error for Claude Code and jq/grep can return it, so
# any unexpected failure must fall through as "allow".
trap 'exit 0' ERR

command -v jq >/dev/null || exit 0

input=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<<"$input")

# Match `git commit` at command position only, so mentions inside arguments
# (e.g. `echo "git commit"`) do not trigger the reminder. Common forms are
# tolerated: git options before `commit` (`-c k=v`, `-C dir`), and before `git`
# VAR=x, env/command/exec/time/nohup, shell keywords (`if`, `then`, `do`, ...)
# or a path to the binary. `commit` must end the word: whitespace, end of line or
# a shell operator (`;` `&` `|` `(` `)` `<` `>`), so `git commit-tree` is not one.
# Known limit: a here-document body that mentions `git commit` matches too. That
# costs one extra denial, and re-running the command passes.
# `word` is one shell word that may glue quoted and unquoted parts
# (`user.name='John Doe'`); its pieces never overlap, so the regex cannot
# backtrack catastrophically.
sp='[[:space:]]+'
word="(\\\\.|\"[^\"]*\"|'[^']*'|[^[:space:]\"'\\\\])+"
git_opt="(-[cC]$sp$word|--(git-dir|work-tree|namespace|super-prefix|config-env)$sp$word|-$word)"
keyword='if|then|elif|else|do|while|until|!|[{]'
prefix="(([A-Za-z_][A-Za-z0-9_]*=($word)?|command|env|exec|time|nohup|$keyword|-$word)$sp)*"
bin='\\?(/[^[:space:]]*/)?'
grep -qE "(^|[;&|(])[[:space:]]*${prefix}${bin}git($sp$git_opt)*${sp}commit([[:space:];&|()<>]|\$)" <<<"$cmd" || exit 0

# Without a session id we cannot tell the first attempt from the retry, and
# denying every time would loop forever, so do nothing.
session=$(jq -r '.session_id // empty' <<<"$input")
session=${session//[^A-Za-z0-9_-]/}
[[ -n $session ]] || exit 0

# The marker means "this exact command was just denied"; re-running it consumes
# the marker. Keying on the command too keeps a different `git commit` from
# slipping through on someone else's retry. It expires so that an abandoned
# attempt cannot wave a later re-run through. The OS clears the temp dir, so
# stray markers need no cleanup here.
marker_dir=${TMPDIR:-/tmp}/claude-git-commit-guard
cmd_hash=$(printf '%s' "$cmd" | cksum | tr ' ' -)
marker=$marker_dir/$session.$cmd_hash
if [[ -e $marker ]]; then
  fresh=$(find "$marker" -mmin -10)
  rm -f "$marker"
  [[ -z $fresh ]] || exit 0
fi

# Headings are kept so the model can tell which section a rule comes from.
section=$(awk '/^## (Git|Interaction)$/ { f = 1; print; next } /^## / { f = 0 } f' "$HOME/.claude/CLAUDE.md" 2>/dev/null || true)
# Denying with no rules to show would only waste a round trip.
[[ -n $section ]] || exit 0

output=$(jq -n --arg section "$section" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("Review the rules below before running git commit. Check that the message follows them, fix it if needed, and re-run. A changed command counts as a different command and triggers this reminder once more; in that case, just re-run it as is.\n\n" + $section)
  }
}')

# Create the marker only after the output is ready, so a failure above never
# leaves a marker behind without the reminder having been shown.
mkdir -p "$marker_dir"
touch "$marker"
printf '%s\n' "$output"
