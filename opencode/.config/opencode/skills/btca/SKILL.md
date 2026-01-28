---
name: btca
description: Retrieve and synthesize context from configured source-code repositories or local paths for deep, non-obvious questions.
---

## What btca is

Better Context (btca) provides searchable, configured sources beyond local files. For git resources, it clones and updates repositories into a local cache, then answers questions from real files with citations and snippets.

## When to use

- The answer is not in local files or common knowledge.
- The question spans multiple repositories, docs, or large specs.
- The project changes frequently or the documentation is immature or outdated.
- A source-backed, traceable answer is needed.

## How to use

1. Clarify the goal and scope.
2. Break the request into small, focused questions.
3. Use single-source or multi-source `btca ask` depending on the scope.
4. For multi-part investigations, run multiple subtasks and consolidate results.
5. Summarize findings with original reasoning and cite sources.

## Agent behavior

- Use btca tools directly, like standard tools such as `read` or `grep`.
- Prefer `btca ask` for external source-code questions; avoid asking the user to run btca manually.
- Produce a synthesized answer, not just raw tool output.

## Tool usage overview

- `btca config resources list`: identify configured sources and their names.
- `btca config resources add`: add missing sources (type `git` or `local`, plus url/path).
- `btca ask`: ask targeted questions against configured resources.
- `btca config model`: optional model change; the CLI may require a timeout.
- `btca config resources remove`: remove stale sources.
- `btca clear`: clear cached clones only when troubleshooting.

## Guardrails

- Avoid recursive `btca ask` loops.
- Do not add private sources without approval.
- Prefer read-only actions; confirm before destructive commands.
