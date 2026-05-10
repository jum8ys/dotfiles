#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
default_message="Claude is waiting for your input"
message=$(jq -r '.message // empty' <<<"$input" 2>/dev/null || true)
[[ -n "$message" ]] || message=$default_message

# Walk up the process tree to find the outermost .app bundle
find_app_bundle() {
  local pid=$PPID
  while [[ $pid -gt 1 ]]; do
    local exe
    exe=$(ps -o comm= -p "$pid" 2>/dev/null) || break
    if [[ "$exe" == *".app/Contents"* ]]; then
      # Extract the outermost .app path (avoid nested helper bundles)
      local app_path="${exe%%.app/*}.app"
      local bundle
      bundle=$(mdls -name kMDItemCFBundleIdentifier -raw "$app_path" 2>/dev/null || true)
      [[ -n "$bundle" && "$bundle" != "(null)" ]] && echo "$bundle" && return
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ') || break
  done
}

activate=$(find_app_bundle || true)

args=(-title "Claude Code" -message "$message" -sound Blow -group claude-code)
[[ -n "$activate" ]] && args+=(-activate "$activate")

if command -v terminal-notifier >/dev/null; then
  (terminal-notifier "${args[@]}" >/dev/null 2>&1 &)
fi
