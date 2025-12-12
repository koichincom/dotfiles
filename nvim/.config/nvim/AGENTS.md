# AGENTS.md

## Build / Lint / Test

- Format: `stylua lua/` or `stylua <file>` (uses `stylua.toml`).
- Lint: `luacheck <file>` (if installed).
- Validate: `nvim --headless -u init.lua -c "checkhealth" -c "qa"`.
- Test all: `busted`.
- Test single: `busted spec/path/to/spec.lua` or `nvim --headless -c "lua require('plenary.test_harness').run({pattern='spec/path/to/spec.lua'})" -c "qa"`.

## Code Style & Conventions

- Language: Lua only. 4-space indent per `stylua.toml`.
- Imports: `local mod = require "module"` (no parens). Load order: core → plugins → modules.
- Modules: `local M = {}; ... return M`. Use `M.init()` for side-effect initialization.
- Plugins: specs in `lua/plugins/*.lua`, load via lazy.nvim with `config = function()`.
- Init: `vim.loader.enable(true)` MUST be first line in `init.lua` for bytecode caching.
- Options: static baseline in `core/options.lua`; dynamic options only in modules. Use `vim.wo`/`vim.bo`/`vim.go` in hot paths.
- Naming: descriptive names preferred; avoid single-letter vars except tiny loops.
- Error handling: validate inputs/state early, use early returns, degrade gracefully.

## Repo-specific notes

- Winbar: `lua/modules/winbar/` uses components. Update via `winbar.update_component(name, params)`.
- Autocmds: define in `core/autocmds.lua` with `init_*()` functions.
- Copilot: config at `lua/plugins/copilot.lua` — accept key `<C-J>`; keep integration minimal.
- Cursor/Copilot rules: none found (no `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md`).
