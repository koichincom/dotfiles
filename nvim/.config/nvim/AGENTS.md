# AGENTS.md

Neovim configuration guide for agentic coding assistants. This document describes build/test/lint commands, code conventions, architectural patterns, and repo-specific behaviors.

---

## Build / Lint / Test

### Formatting

- **Command**: `stylua lua/` or `stylua <file>`
- **Config**: `stylua.toml` (4-space indent, Spaces)
- **Runtime**: conform.nvim in `lua/plugins/formatter.lua`
    - Supports: Lua (stylua), Python (ruff_format), JS/TS/HTML/CSS/JSON/MD (prettier), C/C++ (clang-format), Zig (zigfmt)
    - Format on save enabled (500ms timeout)

### Linting

- **Command**: `luacheck <file>` (if installed)
- **Runtime**: nvim-lint in `lua/plugins/linter.lua`
    - Supports: Python (ruff), Lua (luacheck), JS/TS (eslint_d), C/C++ (cpplint), HTML, CSS, Markdown, JSON
    - Triggers: InsertLeave, BufWritePost, TextChanged

### Testing

- **Framework**: busted + plenary (documented but no tests exist yet)
- **Test all**: `busted`
- **Test single**: `busted spec/path/to/spec.lua` or `nvim --headless -c "lua require('plenary.test_harness').run({pattern='spec/path/to/spec.lua'})" -c "qa"`
- **Note**: No `spec/` directory exists; test infrastructure planned but not implemented

### Validation

- **Health check**: `nvim --headless -u init.lua -c "checkhealth" -c "qa"`
- **Manual check**: `:checkhealth` in running Neovim session

### CI/Deployment

- **Status**: No CI configured (no `.github/workflows/` or other CI files)

---

## Code Style & Conventions

### Language & Formatting

- **Language**: Lua only
- **Indentation**: 4 spaces (per `stylua.toml` and `.editorconfig`)
- **Line length**: No hard limit (stylua default)

### Imports & Load Order

- **Import style**: `local mod = require "module"` (no parentheses unless passing multiple args)
- **Load order**: core → plugins → modules (see `init.lua`)
- **Lazy loading**: Use module-level variables set to `nil`, load on first use (see `core/autocmds.lua:4`)

### Modules

- **Pattern**: `local M = {}; ... return M`
- **Initialization**: Use `M.init()` for one-time side-effect initialization
- **State**: Private state as module-level local variables (e.g., `local last_os_theme`)
- **Example**:

    ```lua
    local M = {}
    local state = nil  -- Private state

    function M.init()
        -- One-time initialization
        state = {}
    end

    function M.do_something()
        if not state then M.init() end
        -- Function logic
    end

    return M
    ```

### Plugins

- **Location**: `lua/plugins/*.lua` (one plugin per file)
- **Pattern**: Each file returns a lazy.nvim plugin spec table
- **Loading**: Via lazy.nvim with `{ import = "plugins" }` in `core/lazy.lua`
- **Spec structure**:
    ```lua
    return {
        "author/plugin-name",
        dependencies = { ... },      -- Optional
        event = "VimEnter",           -- Optional lazy-loading
        config = function()           -- Setup function
            require("plugin").setup({ ... })
            -- Keymaps, autocmds, integrations
        end,
        -- OR use opts = { ... } for simple setup()
    }
    ```
- **Examples**: See `lua/plugins/telescope.lua` (dependencies + extensions), `lua/plugins/gitsigns.lua` (opts pattern)

### Autocmds

- **Location**: `core/autocmds.lua` (centralized)
- **Pattern**: Module with `init_*()` functions for different feature groups
- **Groups**: Feature-based augroups (MyWinbar, MyHighlight, MyCursorline, MyBackground, MyFileSync, MyList, MyWrap, MyAutoWrite, MyLint)
- **Integration**: Plugins call `autocmds.init_*()` from their config functions (see `gitsigns.lua:12`)
- **Naming**: `M.init_general()` for core autocmds (called from `init.lua`), `M.init_<plugin>()` for plugin-specific

### Keymaps

- **Leader**: Space (`vim.g.mapleader = " "`)
- **Global**: Minimal global keymaps in `core/keymaps.lua`
- **Plugin-specific**: Defined in plugin config functions (e.g., `gh-copilot.lua`, `telescope.lua`)
- **Format**: `vim.keymap.set(mode, lhs, rhs, { desc = "Description", ... })`
- **Descriptive**: Always include `desc` for which-key and discoverability

### Options

- **Static baseline**: `core/options.lua` only
- **Dynamic options**: Set in modules (e.g., `wrap.lua`, `list.lua`)
- **Scope-specific**: Use `vim.wo` (window), `vim.bo` (buffer), `vim.go` (global) in hot paths for performance
- **Avoid**: Setting options in autocmd callbacks unless necessary

### Naming

- **Variables**: Descriptive names preferred (e.g., `last_os_theme`, not `t`)
- **Functions**: Snake_case (e.g., `get_updated_theme`, `update_component`)
- **Single-letter**: Only in tiny loops or well-known conventions (e.g., `i` in `for i, v in ipairs()`)
- **Booleans**: Prefix with `is_`, `has_`, `should_` (e.g., `is_enabled`, `has_errors`)

### Error Handling

- **Validate early**: Check inputs/state at function entry, use early returns
- **pcall for external**: Wrap external calls (e.g., `pcall(require, "plugin")`) to avoid breaking on missing deps
- **Degrade gracefully**: Return `nil` or default values on error; avoid throwing unless critical
- **Example** (from `background.lua:39-42`):
    ```lua
    if not theme then
        return nil  -- Fallback if detection failed
    end
    ```

### Comments & Documentation

- **When**: Document non-obvious logic, complex algorithms, or public APIs
- **Style**: `-- Comment` for single-line, `--[[ ... ]]` for multi-line (rare)
- **Avoid**: Redundant comments that just restate code

### Performance

- **Hot paths**: Use `vim.wo`/`vim.bo`/`vim.go` instead of `vim.opt` (see `core/options.lua` comment)
- **Lazy loading**: Load modules on first use, not at startup (see `core/autocmds.lua:18-26`)
- **Bytecode caching**: `vim.loader.enable(true)` MUST be first line in `init.lua`
- **Batch API calls**: Prefer batching `nvim_set_hl` calls (TODO.md P1 item)
- **Debounce**: Consider debouncing winbar/statusline updates (TODO.md P1 item)

---

## Architecture Overview

### Component-Based Winbar System

- **Location**: `lua/modules/winbar/`
- **Structure**: `main.lua` + `components/{buffer,editor,project}.lua`
- **Pattern**: Component map with state + getter functions (see `winbar/main.lua:7-47`)
- **Updates**: `winbar.update_component(name, params)` triggers state comparison and re-render only if changed
- **Components**: cwd, diagnostics, git_branch, file_path_name, encode, file_mod, wrap, gh_copilot, auto_write
- **Integration**: Plugins/modules call `update_component()` to update winbar state (e.g., `gh-copilot.lua:27`, `gitsigns.lua:9`)

### Highlight Namespace System

- **Location**: `lua/modules/highlight/`
- **Namespaces**: 16 total (2 activities × 2 themes × 4 modes)
    - Activities: active/inactive window
    - Themes: light/dark
    - Modes: normal/insert/visual/command
- **Pattern**: Lazy-load namespaces on first use, cache in module state
- **API**: `highlight.switch_namespace(is_active, is_light, mode, render_immediately, force_update_all_windows)`
- **Integration**: Autocmds call `switch_namespace()` on WinEnter/WinLeave, ModeChanged, theme change

### Auto-Write System

- **Location**: `lua/modules/auto-write.lua`
- **Pattern**: `vim.o.autowriteall = true` + `vim.o.hidden = false`
- **Behavior**: Saves on buffer leave, window leave, focus lost
- **Use case**: Integration with external tools (Opencode, Claude Code)

### Background Detection

- **Location**: `lua/modules/background.lua`
- **Pattern**: Poll OS theme (macOS `defaults`, Linux `gsettings`), sync colorscheme + highlight namespaces
- **Trigger**: FocusGained autocmd
- **Fallback**: Returns `nil` if detection fails or theme unchanged (early return pattern)

---

## Repo-Specific Notes

### Init Order (Critical)

1. `vim.loader.enable(true)` — MUST be first line in `init.lua` for bytecode caching
2. `core.globals` → `core.options` → `core.lazy` (loads plugins)
3. `modules.colorscheme.init()` — After colorscheme plugins loaded
4. `modules.highlight.main.init()` — After colorscheme module
5. `core.autocmds.init_general()` — After highlight module
6. `core.keymaps` — Last

### Winbar

- **Update components**: `require("modules.winbar.main").update_component(name, params)`
    - Pass `nil` for `params` to trigger re-fetch from getter
    - Pass value for `params` to directly set state
- **Examples**: `gh-copilot.lua:27`, `gitsigns.lua:9`

### Autocmds

- **Define**: In `core/autocmds.lua` with `init_*()` functions
- **Call**: From `init.lua` (`init_general()`) or plugin config functions (`init_gitsigns()`, `init_lint()`)
- **Pattern**: Lazy-load module dependencies inside `init_*()` functions (see `autocmds.lua:18-26`)

### GitHub Copilot

- **Config**: `lua/plugins/gh-copilot.lua`
- **Accept key**: `<C-J>` (not Tab)
- **Toggle**: `<leader>tc`
- **Integration**: Minimal; avoid heavy customization per AGENTS.md philosophy

### Oil.nvim

- **Use case**: Directory editing as buffers
- **Special handling**: Winbar skips rendering for `buftype ~= ""` (see component getters)

### fff.nvim

- **Config**: `lua/plugins/fff.lua`
- **Guide**: See `FFF_GUIDE.md` for usage details

### Cursor/Copilot Rules

- **Status**: None found (no `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md`)
- **Philosophy**: Keep AI tool integrations minimal and non-intrusive

---

## Common Pitfalls & Tips

### Pitfall: Breaking init order

- **Issue**: Loading highlight module before colorscheme causes wrong colors at startup
- **Solution**: Follow init order in `init.lua` exactly (see "Init Order" above)

### Pitfall: Forgetting to apply highlight namespace

- **Issue**: Creating namespace but not calling `nvim_win_set_hl_ns()` (fixed in TODO.md done list)
- **Solution**: Use `switch_namespace()`, not `load_namespace()` directly

### Pitfall: Setting options in wrong place

- **Issue**: Dynamic options in `core/options.lua` causes conflicts
- **Solution**: Static baseline in `core/options.lua`, dynamic in modules only

### Tip: Debugging autocmds

- `:autocmd` to list all autocmds
- `:verbose autocmd <event>` to see which autocmds fire for an event

### Tip: Profiling startup

- `nvim --startuptime startup.log` to profile startup time
- Ensure `vim.loader.enable(true)` is first line for bytecode caching
