# Todo

## P0

## P1

- [ ] Configure Opencode.nvim: whether to have the screen inside neovim or outside
    - [ ] Before sending any lines, I should format and save the buffer first
- [ ] Winbar module system finalization
    - [x] Init order issue
    - [x] branch's component_map: combine the 3 separated ones
    - [x] fix the status components integration (probably need to look into the each module)
    - [x] Branch component initialization
    - [x] file_mod and wrap initialization
    - [x] Core winbar components (path, encoding, file_mod, auto_save, wrap)
          ：q - [x] Special buffer handling (skip render for buftype ~= "")
    - [x] vim.opt investigation - not applicable for winbar (string-only option, table.concat is optimal)
    - [x] Copilot indicator component (After setting up llm-completion module system)
    - [x] Layout update (Left-Center-Right)
    - [x] Exception-based status logic (!Save, !AI, Wrap)
    - [x] Visual update (Dot for modified, specific icons)
    - [x] CWD indicator component (implement logic)
    - [ ] Git branch component (fix gitsigns integration)
        - [x] Refactor to single component: merge get_branch() and get_hide() logic to return "" for special buffers
        - [x] Remove git_branch_hide and git_branch_display from components_map
        - [x] Simplify render() to use git_branch.state directly
        - [ ] Fix autocmd triggers for buftype changes: Determine if BufEnter or OptionSet buftype is needed to hide/show branch in special buffers
        - [ ] Fix autocmd triggers for git branch changes: Find reliable way to detect branch changes (currently using FocusGained, but doesn't cover in-Neovim git commands)
    - [ ] Diagnostics component (implement error count)
        - [x] Refactor to single component: merge get_diagnostics() and get_hide() logic to return "" for special buffers
        - [x] Remove diagnostics_hide from components_map
        - [x] Simplify render() to use diagnostics.state directly
        - [ ] Fix autocmd triggers: Determine if OptionSet buftype is needed or if BufEnter + DiagnosticChanged is sufficient
    - [x] Finalize the modified indicator component (currently somehow unstable), make sure it shows if the current buffer is modified and not saved
    - [x] Autosave indicator
        - [x] Consider autowriteall and autowrite options interaction, the former is set, the latter is not
    - [x] Edge case when the internal value is changed in the situation where the redering is skipped, and then enter a non-skipped buffer should trigger the re-rendering
    - [x] Don't skip rendering in Oil

## P2

- [ ] Implement debounce/throttle/schedule for winbar updates
- [ ] Batch nvim_set_hl calls in highlight system to minimize performance impact
- [ ] vim.opt.winbarnc might be refactored the code a lot
- [ ] LSP keymaps: go to definition, references, etc.
- [ ] Very hard but try to trigger oil preview when entering

## P3

- [ ] Consider fff.nvim super fast file searcher
- [ ] Configure scratch (oil preview) to the list (4 spaces indent or completely remove them)
- [ ] Configure preset.lua (currently AI generated)
- [ ] Winbar: word count in markdown files (after count.nvim is completed)
- [ ] Learn: schedule and wrap to safely execute autocmd callbacks in Neovim
- [ ] Learn: quickfix, jumplist, vim marks
- [ ] Learn: nvim-surround usage
- [ ] Search harpoon

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
