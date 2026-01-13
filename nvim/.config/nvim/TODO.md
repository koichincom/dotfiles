# Todo

## P0

- [ ] Stablize Treesitter (everything is broken after starting to use this Thinkpad)
- [ ] Set up Quarto (and use Jupyter notebooks inside Neovim)

## P1

- [ ] Set LSP keymaps
- [ ] Configure Opencode.nvim display mode (embedded vs external)
    - [ ] Implement save before sending lines to Opencode
- [ ] Implement conditional formatting: only format on manual saves, not on auto-saves
    - Problem: Auto-save on FocusLost triggers formatting, which is annoying when working file is formatted
    - Solution: Use buffer-local flag to distinguish manual saves from auto-saves
    - [ ] Modify lua/plugins/conform.lua: make format_on_save a function that checks vim.b.is_manual_save flag
    - [ ] Add keymap for manual save that sets the flag before writing (decide: <leader>w vs override :w)
    - [ ] Test: FocusLost should save without formatting, manual save should format
    - Reference: conform.nvim format_on_save can be function(bufnr) returning opts or nil
- [ ] Learn and add some copilot settings
- [ ] Investigate vim.opt.winbarnc for potential winbar refactoring
- [ ] Implement debounce/throttle for winbar updates to improve performance
- [ ] Batch nvim_set_hl calls in highlight system to reduce API overhead

## P2

- [ ] Learn quickfix list, jumplist, and vim marks
- [ ] Implement dynamic filepath truncation based on window width in winbar

## P3

- [ ] Trigger oil.nvim preview automatically when entering directories
- [ ] Evaluate harpoon for file navigation
- [ ] Configure oil.nvim scratch buffer list formatting (adjust/remove 4-space indent)
- [ ] Add word count component to winbar for markdown files (depends on count.nvim)
- [ ] Learn vim.schedule() and vim.schedule_wrap() for safe autocmd callbacks
- [ ] Learn nvim-surround keybindings and usage patterns

## Done

- [x] New way of triggering linting and formatting
    - [x] Formating trigger update
    - [x] Linting trigger update
- [x] Learn: autoread and how to reload files from outside changes (e.g., Claude Code) Implemented via vim.o.autoread and FocusGained autocmd
- [x] Autosave adjustments for external tools like Opencode, Claude Code
- [x] I may need to set up global namespace for fallback on startup (reference: https://opencode.ai/s/QzY5hMnO)
- [x] Reconsider autowrite system given i found vim.o.autowriteall
    - [x] Refactor autowrite logic with vim.o.autowriteall and related (now everything is changed!)
    - [x] Remove the custom auto-save component logic
- [x] Update highlight presets for light mode especially
- [x] Organize the plugin files by changing the names and separating by one plugin per file
- [x] Only use copilot.vim, not supermaven
- [x] Add modes highlight namespaces for each category (2 _ 2 _ 4 namespaces)
- [x] Add winbar specific values for the highlight presets
- [x] Integrate highlight namespace system endpoints
    - [x] Update ModeChanged autocmds (4 patterns: n/i/v/c) to call switch_namespace(nil, nil, mode, true) where mode is "normal"/"insert"/"visual"/"command"
    - [x] Update WinEnter/WinLeave autocmds to use new 4-param API: switch_namespace(is_active, nil, nil, true) where is_active is true/false
    - [x] Update background.lua theme switching to call switch_namespace(nil, is_light, nil, false) where is_light matches theme
    - [x] Add TabEnter autocmd to sync all windows in new tab: switch_namespace(nil, nil, nil, true, true) with force_update
- [x] Add Kanagawa.nvim theme support (but unused)
- [x] Add nvim-colorizer to highlight code
- [x] List module: dynamic shiftwidth and leadmultispace updates
    - [x] Initialize shiftwidth per filetype (e.g., Lua=2, Python=4) on BufEnter/FileType
    - [x] Update leadmultispace on OptionSet shiftwidth (runtime adaptation)
- [x] Fix highlight namespace not applied at startup (lua/modules/highlight/main.lua:40-56)
    - Issue: M.init() calls load_namespace() but never calls nvim_win_set_hl_ns() to apply it
    - Result: Github-theme colors show on startup until first mode change (e.g., entering insert mode)
    - Solution: Replaced load_namespace() call with M.switch_namespace() to both load and apply
    - Implementation: M.switch_namespace(true, is_light, "normal", false) to handle edge case of multiple windows at startup
- [x] Winbar module system major update
    - [x] Init order issue
    - [x] branch's component_map: combine the 3 separated ones
    - [x] fix the status components integration (probably need to look into the each module)
    - [x] Branch component initialization
    - [x] file_mod and wrap initialization
    - [x] Core winbar components (path, encoding, file_mod, auto_save, wrap)
        - [x] Special buffer handling (skip render for buftype ~= "")
    - [x] vim.opt investigation - not applicable for winbar (string-only option, table.concat is optimal)
    - [x] Copilot indicator component (After setting up llm-completion module system)
    - [x] Layout update (Left-Center-Right)
    - [x] Exception-based status logic (!Save, !AI, Wrap)
    - [x] Visual update (Dot for modified, specific icons)
    - [x] CWD indicator component (implement logic)
    - [x] Git branch component (fix gitsigns integration)
        - [x] Refactor to single component: merge get_branch() and get_hide() logic to return "" for special buffers
        - [x] Remove git_branch_hide and git_branch_display from components_map
        - [x] Simplify render() to use git_branch.state directly
        - [x] Fix autocmd triggers
    - [x] Diagnostics component (implement error count)
        - [x] Refactor to single component: merge get_diagnostics() and get_hide() logic to return "" for special buffers
        - [x] Remove diagnostics_hide from components_map
        - [x] Simplify render() to use diagnostics.state directly
        - [x] Add warning count alongside error count
        - [x] Fix autocmd triggers
    - [x] Finalize the modified indicator component (currently somehow unstable), make sure it shows if the current buffer is modified and not saved
    - [x] Autosave indicator
        - [x] Consider autowriteall and autowrite options interaction, the former is set, the latter is not
    - [x] Edge case when the internal value is changed in the situation where the redering is skipped, and then enter a non-skipped buffer should trigger the re-rendering
    - [x] Don't skip rendering in Oil
    - [x] Complete redesign of winbar module order and layout
- [x] Organize the autocmds with group names, and consider the order of the autocmds
- [x] Fix bug: diagnostics not updating when opening terminal buffers
- [x] Evaluate fff.nvim as a fast file searcher alternative
- [x] Try cloak.nvim for sensitive data hiding
- [x] Encode isn't working I guess
