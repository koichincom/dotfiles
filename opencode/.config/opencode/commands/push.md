---
description: Execute the planned Git commits and push.
agent: build
model: github-copilot/gpt-5-mini
---

Your planned commits from the previous conversation now look good to me. Please execute the plan exactly: commit only the planned changes, then push the current branch to its upstream. After a successful push, report a brief `git status` summary.

- If the plan has multiple commits, follow that and do not combine them. Make sure that the number of commits in the plan and the number of commits you create match exactly.
- A concrete commit plan exists (messages and file scope). If you cannot specify it, stop and report.
- Do not include unrelated files. Include both tracked and untracked files that are explicitly in the plan.
- When staging for each commit, treat tracked and untracked equally (e.g., `git add -A <planned paths>`).
- Do not amend or force-push.
- If any hook fails, a hook modifies files, or any git command errors, stop and report the issue.
