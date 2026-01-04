---
description: Plan modular git commits with conventional messages
agent: plan
---

Analyze the current git changes and plan well-structured, atomic commits.

## Current Repository State

Git status:
!`git status --short`

Unstaged changes:
!`git diff`

Staged changes:
!`git diff --staged`

Recent commits (for style reference):
!`git log --oneline -5`

Untracked files:
!`git ls-files --others --exclude-standard`

## Arguments

$ARGUMENTS

## Security Check (MANDATORY)

@skill/git-secret-scan/SKILL.md

## Instructions

### Step 0: Execute Security Scan
Before planning any commits, follow the git-secret-scan skill instructions above:
1. Scan all diff outputs and untracked files for sensitive patterns
2. Check .gitignore coverage for detected sensitive files
3. If sensitive data is detected:
   - STOP. Do NOT plan any commits.
   - Report findings using the skill's severity levels (CRITICAL/HIGH/SEVERE/INFO)
   - Provide specific remediation steps from the skill
   - Use TodoWrite to create remediation tasks instead of commit tasks
4. Only proceed to Step 1 if NO sensitive data is found

### Step 1: Determine Scope
- If argument is "all": treat both staged and unstaged changes equally, reconsidering commit scope from scratch.
- If no argument: focus ONLY on unstaged changes, ignore the staged changes section above.

### Step 2: Analyze Changes
- Review the diff output provided above.
- Read source files as needed to understand the intent and context behind changes.

### Step 3: Group into Atomic Commits
CRITICAL: Only plan commits for changes that ACTUALLY EXIST in the diff output above.
Do NOT suggest commits for changes that should be made but are not in the diff.
If you notice something that should be done (e.g., add a file to .gitignore), do NOT include it as a planned commit. That is outside the scope of this command.

Each commit should represent ONE logical change. Good modular commits are:
- Based ONLY on the changes shown in the diff output.
- Independently reviewable and revertible.
- Focused on a single purpose (do not mix refactoring with bug fixes).
- Ordered logically (dependencies first).

Separate commits for: refactoring, features, bug fixes, docs, tests, config changes.

### Step 4: Write Commit Messages
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

### Step 5: Execution (Mandatory)
You MUST perform these actions in this exact order:

1. **Record the Plan**: Use the `TodoWrite` tool to create the todo items.
   - content: the full commit message (Subject + optional Body)
   - status: pending
   - priority: high (fixes), medium (features), low (docs/chore)

2. **Report Summary**: ONLY after the tool has successfully run, output the text summary:
   - Total number of commits planned.
   - Ordered list of commit messages.
   - Brief rationale for your grouping decisions.

CRITICAL: Do not output the text summary if you have not called the TodoWrite tool.

Do NOT execute any commits. Only plan and add to the todo list.
