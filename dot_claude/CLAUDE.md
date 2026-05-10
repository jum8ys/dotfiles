# CLAUDE.md

## Git

- Do not include `Co-Authored-By` in commit messages
- Commit messages must follow Conventional Commits v1.0.0 with a Gitmoji prefix
- Before running `git commit`, always show the planned command (including the full commit message) and ask for confirmation, even when the user has already asked to commit
- Ask for confirmation before running `git push`
- Split commits by logical unit of change — one concern per commit (e.g. separate refactors, feature additions, and config changes into distinct commits)
- Use `git restore --staged` instead of `git reset` to unstage files
- Do not use `git -C <path>` when already in the correct working directory

### Commit Message Format

```
<emoji> <type>[(<scope>)][!]: <description>

[optional body]

[optional footer(s)]
```

**Rules:**
- `type` and `description` are mandatory; `scope` is optional (in parentheses)
- `description`: lowercase, no trailing period
- Body and footers are each separated from the preceding section by a blank line
- Body is **optional** — omit it when the subject already conveys intent and motivation
- When a body is needed, use concise `- ` bullet points (not prose) and focus on the *why* (motivation, prior context, side effects, test rationale) — not the *what* that the diff already shows
- Breaking change: append `!` after type/scope and add `BREAKING CHANGE: <details>` footer

**Type → Emoji:**

| Emoji | Type | Use when |
|---|---|---|
| ✨ | `feat` | New feature |
| 🐛 | `fix` | Bug fix |
| 🚑️ | `fix` | Critical hotfix |
| 📝 | `docs` | Documentation only |
| 🎨 | `style` | Formatting, whitespace (no logic change) |
| ♻️ | `refactor` | Neither fix nor feature |
| ⚡️ | `perf` | Performance improvement |
| ✅ | `test` | Add or update tests |
| 📦️ | `build` | Build system or dependencies |
| 👷 | `ci` | CI/CD configuration |
| 🔧 | `chore` | Tooling, config, maintenance |
| ⏪️ | `revert` | Revert a previous commit |
| 💥 | any + `!` | Breaking change (combine with type emoji) |

**Examples:**
```
✨ feat(auth): add OAuth2 login
🐛 fix(api): handle empty response
📝 docs: update installation guide
♻️ refactor(db): extract query builder
💥 feat(api)!: remove deprecated endpoints

BREAKING CHANGE: v1 endpoints have been removed
```

## Code

- Write comments in English
- Ask for confirmation before adding new packages or dependencies

## Commands

- Before running any command, briefly explain in plain language what it will do (in Japanese)
- Use the `Read` tool instead of `cat`, `head`, or `tail` to read files
- Use the `Edit` tool instead of `sed` or `awk` to edit files
- Use the `Write` tool instead of `echo >` or heredoc to write files
- Use `gh` CLI for all GitHub operations instead of `curl` API calls
