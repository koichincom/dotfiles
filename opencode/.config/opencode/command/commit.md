---
description: Plan git commits
agent: plan
model: google/antigravity-gemini-3-flash
---

Analyze the current git changes and plan well-structured, atomic commits.

## Instructions

### Step 0: Gather Repository State

Understand the current state of the git repository by reading the following outputs:

Git status:
!`git status --short`

Changed files summary:
!`git diff --name-status`
!`git diff --staged --name-status`

Recent commits (for style reference):
!`git log --format=%s -5`

### Step 1: Analyze and Group Changes

**Scope Policy**: Only plan commits for changes that ACTUALLY EXIST in the status output above. Do NOT suggest commits for changes that should be made but are not present. If you notice something that should be done (e.g., add a file to .gitignore), do NOT include it as a planned commit.

**Process**:

- If git status shows NO changes (no staged, no unstaged, no untracked), skip to Step 3 and report "No commits planned."
- Review the changed files summary above.
- For files where you need detailed diff context to understand intent, run `git diff <file>` or `git diff --staged <file>` selectively.
- Only read files that appear in the status to understand context; do not scan unrelated files.

**Grouping Rules**:

Each commit should represent ONE logical change. Prefer the minimum number of commits that keep review clarity; do not split by file or micro-changes. Aim for 1–3 commits unless a clear separation exists (feature/test/docs/config).

Good modular commits are:

- Independently reviewable and revertible.
- Focused on a single purpose (do not mix refactoring with bug fixes).
- Ordered logically (dependencies first).

Separate commits for: refactoring, features, bug fixes, docs, tests, config changes.

### Step 2: Write Commit Messages

Use Conventional Commits format. No emojis.

Format: `<type>(<scope>): <description>`

Types (lowercase): feat, fix, refactor, docs, style, perf, test, chore, ci, build

Description rules:

- Use imperative mood ("Add" not "Added" or "Adds").
- Capitalize first letter of description.
- No period at end.
- Max 50 characters for subject line.
- Be specific and descriptive (e.g., "fix UserService crash" NOT "fix bug").

Body (optional, for complex changes):

- Separate from subject with a blank line.
- Wrap at 72 characters.
- Explain WHAT and WHY, not HOW.

Breaking changes:

- Add `!` after type/scope: `feat(api)!: remove deprecated endpoint`.
- Or add footer: `BREAKING CHANGE: description`.

### Step 3: Execution (Mandatory)

**If NO changes exist** (status was empty), output: "No commits planned." and STOP. Do NOT use TodoWrite.

**If changes exist**, you MUST perform these actions in this exact order:

1. **Record the Plan**: Use the `TodoWrite` tool to create the todo items.
   - content: exactly the subject line (e.g., "feat(ui): add button"). No body, no rationale, no extra text.
   - status: pending
   - priority: high (fixes), medium (features), low (docs/chore)
   - CRITICAL: The Todo list is for the final commit messages ONLY. Do NOT add any other information in the todo content.

2. **Report Summary**: ONLY after the tool has successfully run, output the text summary in this format:
   - Total number of commits planned.
   - For each planned commit:
     ### <Subject Line>
     - **Reasoning**: <Brief explanation of why this is a separate commit and what it covers>

CRITICAL: Do not output the text summary if you have not called the TodoWrite tool. If TodoWrite was not used, STOP and call it first.

Do NOT execute any commits. Only plan and add to the todo list.
