# CLAUDE.md

## Coding Behavior

**Rule 1 — Think Before Coding.**
State assumptions explicitly before writing. Ask rather than guess when uncertain. Push back when a simpler approach exists. Stop when confused and name what's unclear.

**Rule 2 — Simplicity First.**
Write the minimum code that solves the problem. No speculative features, no premature abstractions, no code beyond what was asked.

**Rule 3 — Surgical Changes.**
Touch only what must change. Do not "improve" adjacent code, comments, or formatting outside the scope of the task. Match existing style.

**Rule 4 — Goal-Driven Execution.**
Define success criteria before starting. Loop until verified against that definition — not just until steps are complete.

**Rule 5 — Read Before You Write.**
Before modifying a file, read its exports and immediate callers to understand existing patterns. If the structure is unclear, ask before adding to it.

**Rule 6 — Checkpoint After Every Significant Step.**
After completing each step in a multi-step task, summarize what was done, what was verified, and what remains. Do not continue from a state you cannot describe.

**Rule 7 — Fail Loud.**
Surface uncertainty explicitly. Never present a partial or unverified result as complete. "Done" means verified, not just executed.

## Code

- Write comments in English
- Ask for confirmation before adding new packages or dependencies

## Commands

- Before running any command, briefly explain in plain language what it will do (in Japanese)
- Use the `Read` tool instead of `cat`, `head`, or `tail` to read files
- Use the `Edit` tool instead of `sed` or `awk` to edit files
- Use the `Write` tool instead of `echo >` or heredoc to write files
- Use `gh` CLI for all GitHub operations instead of `curl` API calls

## Git

- Do not include `Co-Authored-By` in commit messages
- Commit messages must follow Conventional Commits v1.0.0 with a Gitmoji prefix
- Before running `git commit`, always show the planned command including the full commit message
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
| 🔒 | `security` | Security fixes and improvements |
| 📝 | `docs` | Documentation only |
| 🎨 | `style` | Formatting, whitespace (no logic change) |
| ♻️ | `refactor` | Neither fix nor feature |
| ⚡️ | `perf` | Performance improvement |
| ✅ | `test` | Add or update tests |
| 📦️ | `build` | Build system or dependencies |
| 👷 | `ci` | CI/CD configuration |
| 🔧 | `chore` | Tooling, config, maintenance |
| 💄 | `ui` | UI and style file changes |
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

## Machine-specific overrides

@~/.claude/CLAUDE.local.md
