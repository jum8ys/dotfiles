#!/usr/bin/env bash
# PreToolUse hook for Bash: gate `gh api graphql` calls.
# - Mutations require explicit user approval.
# - Queries are auto-allowed.
# - When the query is referenced via @file (e.g. `-F query=@x.graphql`),
#   the hook cannot see the contents, so it asks for confirmation as well.

set -euo pipefail

input=$(cat)

if ! echo "$input" | grep -q 'gh api graphql'; then
  exit 0
fi

# `-F`/`-f key=@path` references an external file; we cannot inspect it for
# `mutation`, so escalate to ask. The `@` may be wrapped in quotes (=@, ='@, ="@).
if echo "$input" | grep -qE -- '=["'"'"']?@'; then
  cat <<'JSON'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "GraphQL クエリが @file 参照を含み、内容を確認できません。実行を許可しますか？"}}
JSON
  exit 0
fi

if echo "$input" | grep -qi 'mutation'; then
  cat <<'JSON'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "GraphQL mutation (書き込み) が含まれています。実行を許可しますか？"}}
JSON
else
  cat <<'JSON'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "allow", "permissionDecisionReason": "GraphQL query (読み込みのみ) を自動許可"}}
JSON
fi
