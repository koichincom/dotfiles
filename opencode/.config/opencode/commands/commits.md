---
description: Plan git commits
agent: plan
model: github-copilot/gpt-5-mini
---

Analyze current git changes and plan atomic, well-structured commits.

### Step 0: Gather Repository State

Read the following outputs to understand the repo state:

Git status:
!`git status --short --untracked-files=all`

Changed files summary:
!`git diff --name-status`
!`git diff --staged --name-status`
Untracked files:
!`git ls-files --others --exclude-standard`

Recent commits (for style reference):
!`git log --format=%s -5`

### Step 1: Analyze and Group Changes

**Scope Policy**: Only plan commits for changes that ACTUALLY EXIST in the status output above (including untracked files). Do NOT suggest commits for work that is not present. If you notice follow-ups (e.g., add a file to .gitignore), do NOT include them as planned commits.

**Process**:

- If git status shows NO changes (no staged, no unstaged, no untracked), skip to Step 3 and report "No commits planned."
- Review the changed files summary above (tracked and untracked).
- If you need detailed diff context to understand intent, run `git diff <file>` or `git diff --staged <file>` selectively.
- Only read files that appear in the status to understand context; do not scan unrelated files.

**Grouping Rules**:

Each commit should represent ONE logical change. Prefer the minimum number of commits that keep review clarity; do not split by file or micro-changes. Aim for 1–3 commits unless a clear separation exists (feature/test/docs/config).

Good modular commits are:

- Independently reviewable and revertible.
- Focused on a single purpose (do not mix refactoring with bug fixes).
- Ordered logically (dependencies first).

Separate commits for: refactoring, features, bug fixes, docs, tests, config changes.

### Step 2: Write Commit Messages

Use Conventional Commits. No emojis.

Format: `<type>(<scope>): <description>`

Types (lowercase): feat, fix, refactor, docs, style, perf, test, chore, ci, build

Description rules:

- Use imperative mood ("Add" not "Added" or "Adds").
- Capitalize first letter of description.
- No period at end.
- Subject line max 50 characters.
- Be specific and descriptive (e.g., "fix UserService crash" NOT "fix bug").

Body (optional, for complex changes):

- Separate from subject with a blank line.
- Wrap at 72 characters.
- Explain WHAT and WHY, not HOW.

Breaking changes:

- Add `!` after type/scope: `feat(api)!: remove deprecated endpoint`.
- Or add footer: `BREAKING CHANGE: description`.

### Step 3: Output (Mandatory)

**If NO changes exist** (status was empty), output: "No commits planned." and STOP.

**If changes exist**, output the text summary in this format: - Total number of commits planned. - For each planned commit: ### <Subject Line> - **Reasoning**: <Brief explanation of why this is a separate commit and what it covers>

Do NOT execute any commits. Only plan and report.
