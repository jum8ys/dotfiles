#!/usr/bin/env bash
# PreToolUse hook for Bash: block `git restore` without `--staged`.
# `git restore <file>` discards working-tree changes and cannot be undone.
# Only `git restore --staged` (unstage) is permitted.

set -euo pipefail

input=$(cat)

if ! echo "$input" | grep -q 'git restore'; then
  exit 0
fi

if echo "$input" | grep -q -- '--staged'; then
  cat <<'JSON'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "git restore --staged はアンステージ操作です。実行を許可しますか？"}}
JSON
else
  cat <<'JSON'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "git restore（--staged なし）はワーキングツリーの変更を破棄するためブロックしました。アンステージには git restore --staged を使用してください。"}}
JSON
fi
