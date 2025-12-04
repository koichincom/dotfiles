# AGENTS.md

## Build / Lint / Test

- Format: `stylua lua/` or `stylua <file>` (uses `stylua.toml`).
- Lint: `luacheck <file>` (if installed).
- Validate runtime: `nvim --headless -u init.lua -c "checkhealth" -c "qa"`.
- Test (all): `busted`.
- Test (single spec): `busted spec/path/to/spec.lua` or
  `nvim --headless -c "lua require('plenary.test_harness').run({pattern='spec/path/to/spec.lua'})" -c "qa"`.

## Code Style & Conventions

- Language: Lua only. Use 4-space indent and follow `stylua.toml` formatting.
- Imports: `local mod = require "module"` (no parentheses). Keep load order: core → plugins → modules.
- Modules: `local M = {}; ... return M`. Provide `M.init()` for side-effect initialization.
- Plugins: specs in `lua/plugins/*.lua`, load via lazy.nvim and configure with `config = function()`.
- Init: `vim.loader.enable(true)` MUST be the first line in `init.lua` for bytecode caching.
- Options: set static baseline in `core/options.lua`; dynamic options only in modules. Use `vim.wo`/`vim.bo`/`vim.go` in hot paths.
- Naming: prefer descriptive names; avoid single-letter variables except in tiny loops.
- Error handling: validate inputs and state early, use early returns, and degrade gracefully rather than throwing.

## Repo-specific notes

- Winbar: `lua/modules/winbar/` uses components. Update via `winbar.update_component(name, params)`.
- Autocmds: define in `core/autocmds.lua` with `init_*()` functions.
- Copilot: repo includes Copilot config at `lua/plugins/copilot.lua` — accept key is `<C-J>`; keep Copilot integration minimal.
- Cursor/Copilot rules: no `.cursor/rules/` or `.cursorrules` found; no `.github/copilot-instructions.md` found.
