local M = {}

-- Create feature-based augroups
local winbar_general_group = vim.api.nvim_create_augroup("MyWinbar", { clear = true })
local winbar_gitsigns_group = vim.api.nvim_create_augroup("MyWinbarGitsigns", { clear = true })
local highlight_group = vim.api.nvim_create_augroup("MyHighlight", { clear = true })
local cursorline_group = vim.api.nvim_create_augroup("MyCursorline", { clear = true })
local background_group = vim.api.nvim_create_augroup("MyBackground", { clear = true })
local file_sync_group = vim.api.nvim_create_augroup("MyFileSync", { clear = true })
local list_group = vim.api.nvim_create_augroup("MyList", { clear = true })
local wrap_group = vim.api.nvim_create_augroup("MyWrap", { clear = true })
local auto_write_group = vim.api.nvim_create_augroup("MyAutoWrite", { clear = true })
local lint_group = vim.api.nvim_create_augroup("MyLint", { clear = true })
local gh_copilot_group = vim.api.nvim_create_augroup("MyGhCopilot", { clear = true })

function M.init_general()
    local winbar = require("modules.winbar.main")
    local background = require("modules.background")
    local list = require("modules.list")
    local wrap = require("modules.wrap")
    local cursor_line = require("modules.cursorline")
    local highlight = require("modules.highlight.main")
    local auto_write = require("modules.auto-write")

    -- Highlight group
    vim.api.nvim_clear_autocmds({ group = highlight_group })
    vim.api.nvim_create_autocmd("WinLeave", {
        group = highlight_group,
        callback = function()
            highlight.switch_namespace(false, nil, nil, true)
        end,
    })

    vim.api.nvim_create_autocmd("WinEnter", {
        group = highlight_group,
        callback = function()
            highlight.switch_namespace(true, nil, nil, true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = highlight_group,
        pattern = "*:n*",
        callback = function()
            highlight.switch_namespace(nil, nil, "normal", true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = highlight_group,
        pattern = "*:i*",
        callback = function()
            highlight.switch_namespace(nil, nil, "insert", true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = highlight_group,
        pattern = { "*:v*", "*:V*", "*:\22*", "*:R" },
        callback = function()
            highlight.switch_namespace(nil, nil, "visual", true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = highlight_group,
        pattern = "*:c*",
        callback = function()
            highlight.switch_namespace(nil, nil, "command", true)
        end,
    })

    -- Cursorline group
    vim.api.nvim_clear_autocmds({ group = cursorline_group })
    vim.api.nvim_create_autocmd("WinLeave", {
        group = cursorline_group,
        callback = function()
            cursor_line.turn_off()
        end,
    })

    vim.api.nvim_create_autocmd("WinEnter", {
        group = cursorline_group,
        callback = function()
            cursor_line.turn_on()
        end,
    })

    -- Background group
    vim.api.nvim_clear_autocmds({ group = background_group })
    vim.api.nvim_create_autocmd("FocusGained", {
        group = background_group,
        callback = function()
            background.update()
        end,
        desc = "Should be prioritized to reduce the flash",
    })

    -- FileSync group
    vim.api.nvim_clear_autocmds({ group = file_sync_group })
    vim.api.nvim_create_autocmd("FocusGained", {
        group = file_sync_group,
        callback = function()
            vim.cmd("checktime")
        end,
    })

    -- List group
    vim.api.nvim_clear_autocmds({ group = list_group })
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = list_group,
        callback = function()
            list.update_leadmultispace()
        end,
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "shiftwidth",
        group = list_group,
        callback = function()
            list.update_leadmultispace()
        end,
    })

    -- Wrap group
    vim.api.nvim_clear_autocmds({ group = wrap_group })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = wrap_group,
        callback = function(args)
            -- Force update wrap on buffer enter
            wrap.update(vim.bo[args.buf].filetype)
        end,
    })

    -- AutoWrite group
    vim.api.nvim_clear_autocmds({ group = auto_write_group })
    vim.api.nvim_create_autocmd("OptionSet", {
        group = auto_write_group,
        pattern = { "hidden" },
        callback = function()
            auto_write.update_hidden()
        end,
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = auto_write_group,
        pattern = { "autowrite", "autowriteall" },
        callback = function()
            auto_write.update_status()
        end,
    })

    vim.api.nvim_create_autocmd("FocusLost", {
        group = auto_write_group,
        nested = true,
        callback = function()
            auto_write.write()
        end,
        desc = "Autosave on focus lost for external tools like OpenCode, Claude Code",
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = auto_write_group,
        callback = function()
            auto_write.update_status()
        end,
    })

    -- Winbar group
    vim.api.nvim_clear_autocmds({ group = winbar_general_group })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
        group = winbar_general_group,
        callback = function()
            winbar.update_component("file_path_name", nil)
        end,
        desc = "Update winbar file path and name when entering buffer",
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = winbar_general_group,
        callback = function()
            winbar.update_component("encode", nil)
        end,
        desc = "Update winbar file encoding when entering buffer",
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = winbar_general_group,
        pattern = "fileencoding",
        callback = function()
            winbar.update_component("encode", nil)
        end,
        desc = "Update winbar file encoding when fileencoding option changes",
    })

    vim.api.nvim_create_autocmd("BufModifiedSet", {
        group = winbar_general_group,
        callback = function()
            winbar.update_component("file_mod", nil)
        end,
        desc = "Update winbar modification indicator when buffer modified state changes",
    })

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = winbar_general_group,
        callback = function(args)
            -- Don't update if the diagnostics change is not for the current buffer
            if args.buf == vim.api.nvim_get_current_buf() then
                winbar.update_component("diagnostics", nil)
            end
        end,
    })

    -- OptirnSet with buftype might be optimal, but seems unreliable with plugins like Oil here
    -- Checking the buftype might also be ideal, but it's very unstable for Oil and terminal buffers somehow
    vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
        group = winbar_general_group,
        callback = function()
            winbar.update_component("diagnostics", nil)
        end,
    })

    vim.api.nvim_create_autocmd("DirChanged", {
        group = winbar_general_group,
        callback = function()
            winbar.update_component("cwd", nil)
        end,
        desc = "Update winbar current working directory indicator",
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = winbar_general_group,
        callback = function()
            winbar.update_component("cwd", nil)
        end,
        desc = "Initialize winbar cwd component on Vim start",
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = winbar_general_group,
        callback = function()
            winbar.render()
        end,
        desc = "Render winbar on buffer enter in case internal values changed",
    })
end

function M.init_gitsigns()
    local winbar = require("modules.winbar.main")

    vim.api.nvim_clear_autocmds({ group = winbar_gitsigns_group })
    vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "BufEnter" }, {
        group = winbar_gitsigns_group,
        callback = function()
            winbar.update_component("git_branch", true)
        end,
        desc = "FocusGained and TermClose for external and internal git branch "
            .. "changes respectively, and BufEnter for different repo entries",
    })
end

function M.init_lint()
    local lint = require("modules.lint")

    vim.api.nvim_clear_autocmds({ group = lint_group })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = lint_group,
        callback = function()
            lint.main("BufEnter")
        end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = lint_group,
        callback = function()
            lint.main("BufWritePost")
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = lint_group,
        callback = function()
            lint.main("InsertLeave")
        end,
    })
end

function M.init_gh_copilot()
    local gh_copilot = require("modules.gh-copilot")
    vim.api.nvim_clear_autocmds({ group = gh_copilot_group })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = gh_copilot_group,
        callback = function()
            gh_copilot.update_winbar()
        end,
    })
end

return M
