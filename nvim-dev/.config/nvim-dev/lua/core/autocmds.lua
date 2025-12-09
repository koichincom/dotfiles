local M = {}

-- Set to nil to make it sharable across this fill
local highlight, winbar, background, list, wrap, cursor_line, lint, auto_write = nil, nil, nil, nil, nil, nil, nil, nil

-- Use an augroup to avoid duplicate autocmds when the autocmds are reloaded
local global = vim.api.nvim_create_augroup("Global", { clear = true })

function M.init_general()
    if winbar == nil then
        winbar = require("modules.winbar.main")
    end
    background = require("modules.background")
    list = require("modules.list")
    wrap = require("modules.wrap")
    cursor_line = require("modules.cursorline")
    highlight = require("modules.highlight.main")
    auto_write = require("modules.auto-write")

    vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
        group = global,
        callback = function()
            winbar.update_component("file_path_name", nil)
        end,
        desc = "Update winbar file path and name when entering buffer",
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = global,
        callback = function()
            winbar.update_component("encode", nil)
        end,
        desc = "Update winbar file encoding when entering buffer",
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = global,
        pattern = "fileencoding",
        callback = function()
            winbar.update_component("encode", nil)
        end,
        desc = "Update winbar file encoding when fileencoding option changes",
    })

    vim.api.nvim_create_autocmd("BufModifiedSet", {
        group = global,
        callback = function()
            winbar.update_component("file_mod", nil)
        end,
        desc = "Update winbar modification indicator when buffer modified state changes",
    })

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = global,
        callback = function()
            winbar.update_component("diagnostics", nil)
        end,
        desc = "Update winbar diagnostics count when diagnostics change",
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = global,
        pattern = "buftype",
        callback = function()
            if vim.v.option_old == vim.v.option_new then
                return
            end
            winbar.update_component("diagnostics", nil)
            winbar.update_component("git_branch", nil)
        end,
        desc = "Update winbar components when buftype changes (special buffers)",
    })

    vim.api.nvim_create_autocmd("DirChanged", {
        group = global,
        callback = function()
            winbar.update_component("cwd", nil)
        end,
        desc = "Update winbar current working directory indicator",
    })

    vim.api.nvim_create_autocmd("WinLeave", {
        group = global,
        callback = function()
            highlight.switch_namespace(false, nil, nil, true)
            cursor_line.turn_off()
        end,
        desc = "Switch to inactive highlight namespace and disable cursorline",
    })

    vim.api.nvim_create_autocmd("WinEnter", {
        group = global,
        callback = function()
            highlight.switch_namespace(true, nil, nil, true)
            cursor_line.turn_on()
        end,
        desc = "Switch to active highlight namespace and enable cursorline",
    })

    vim.api.nvim_create_autocmd("FocusGained", {
        group = global,
        callback = function()
            background.update()
            vim.cmd("checktime")
        end,
        desc = "Update background theme and check for external file changes",
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
        group = global,
        callback = function()
            list.update_leadmultispace()
        end,
        desc = "Update leadmultispace listchars for current buffer indentation",
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "shiftwidth",
        group = global,
        callback = function()
            list.update_leadmultispace()
        end,
        desc = "Update leadmultispace listchars when shiftwidth changes",
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = global,
        callback = function(args)
            wrap.update(vim.bo[args.buf].filetype)
            winbar.render()
        end,
        desc = "Update wrap settings and render winbar on buffer enter, in case the internal state has been changed while the situation where the rendering is skipped",
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = "*:n*",
        callback = function()
            highlight.switch_namespace(nil, nil, "normal", true)
        end,
        desc = "Switch to normal mode highlight namespace",
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = "*:i*",
        callback = function()
            highlight.switch_namespace(nil, nil, "insert", true)
        end,
        desc = "Switch to insert mode highlight namespace",
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = { "*:v*", "*:V*", "*:\22*", "*:R" },
        callback = function()
            highlight.switch_namespace(nil, nil, "visual", true)
        end,
        desc = "Switch to visual/replace mode highlight namespace",
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = "*:c*",
        callback = function()
            highlight.switch_namespace(nil, nil, "command", true)
        end,
        desc = "Switch to command mode highlight namespace",
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = global,
        pattern = { "hidden" },
        callback = function()
            auto_write.update_hidden()
        end,
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = global,
        pattern = { "autowrite", "autowriteall" },
        callback = function()
            auto_write.update_status()
        end,
        desc = "Update auto-write status when autowrite options change",
    })

    vim.api.nvim_create_autocmd("FocusLost", {
        group = global,
        nested = true,
        callback = function()
            auto_write.write()
        end,
        desc = "Autosave on focus lost for external tools like OpenCode, Claude Code",
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = global,
        callback = function()
            winbar.update_component("cwd", nil)
            auto_write.update_status()
        end,
        desc = "Initialize winbar global state components (cwd, auto-write)",
    })
end

function M.init_gitsigns()
    winbar = require("modules.winbar.main")

    vim.api.nvim_create_autocmd("FocusGained", {
        group = global,
        callback = function()
            winbar.update_component("git_branch", true)
        end,
        desc = "Update git branch for the background branch change, such as 'git switch <branch>'",
    })
end

function M.init_lint()
    lint = require("modules.lint")

    vim.api.nvim_create_autocmd("BufEnter", {
        group = global,
        callback = function()
            lint.main("BufEnter")
        end,
        desc = "Run linter on buffer enter",
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = global,
        callback = function()
            lint.main("BufWritePost")
        end,
        desc = "Run linter after save",
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = global,
        callback = function()
            lint.main("InsertLeave")
        end,
        desc = "Run linter when leaving insert mode",
    })
end

return M
