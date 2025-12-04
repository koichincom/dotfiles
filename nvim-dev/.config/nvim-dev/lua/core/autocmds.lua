local M = {}

-- Set to nil to make it sharable across this fill
local highlight, winbar, background, list, wrap, cursor_line, linting, oil = nil, nil, nil, nil, nil, nil, nil, nil

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
    oil = require("oil")

    vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
        group = global,
        callback = function()
            winbar.update_component("file_path_name", nil)
        end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = global,
        callback = function()
            winbar.update_component("encode", nil)
        end,
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        group = global,
        pattern = "fileencoding",
        callback = function()
            winbar.update_component("encode", nil)
        end,
    })

    vim.api.nvim_create_autocmd("BufModifiedSet", {
        group = global,
        callback = function()
            winbar.update_component("file_mod", nil)
        end,
    })

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = global,
        callback = function()
            winbar.update_component("diagnostics", nil)
        end,
    })

    -- Trigger when buftype changes
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
    })

    vim.api.nvim_create_autocmd("DirChanged", {
        group = global,
        callback = function()
            winbar.update_component("cwd", nil)
        end,
    })

    vim.api.nvim_create_autocmd("WinLeave", {
        group = global,
        callback = function()
            highlight.switch_namespace(false, nil, nil, true)
            cursor_line.turn_off()
        end,
    })

    vim.api.nvim_create_autocmd("WinEnter", {
        group = global,
        callback = function()
            highlight.switch_namespace(true, nil, nil, true)
            cursor_line.turn_on()
        end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
        group = global,
        callback = function()
            background.update()
        end,
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
        group = global,
        callback = function()
            list.update_leadmultispace()
        end,
    })

    vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "shiftwidth",
        group = global,
        callback = function()
            list.update_leadmultispace()
        end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = global,
        callback = function(args)
            wrap.update(vim.bo[args.buf].filetype)
        end,
    })

    -- Directly use Autocmds and pattern to classify modes in C-level performance
    -- Doing this in Lua callback adds unnecessary overhead
    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = "*:n*",
        callback = function()
            highlight.switch_namespace(nil, nil, "normal", true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = "*:i*", -- Insert
        callback = function()
            highlight.switch_namespace(nil, nil, "insert", true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = { "*:v*", "*:V*", "*:\22*", "*:R" }, -- Visual, Visual Line, Visual Block, Replace
        callback = function()
            highlight.switch_namespace(nil, nil, "visual", true)
        end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = global,
        pattern = "*:c*", -- Command
        callback = function()
            highlight.switch_namespace(nil, nil, "command", true)
        end,
    })
end

function M.init_gitsigns()
    winbar = require("modules.winbar.main")

    -- This doesn't cover the case where the branch is changed inside Neovim,
    -- to cover the case, wrap the commands themselves would be the way to go
    vim.api.nvim_create_autocmd("FocusGained", {
        group = global,
        callback = function()
            winbar.update_component("git_branch", true)
        end,
        desc = "Update git branch for the background branch change, such as 'git switch <branch>'",
    })
end

function M.init_linting()
    linting = require("lint")

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = global,
        callback = function()
            if vim.bo.buftype ~= "" then
                return
            end
            linting.try_lint()
        end,
    })
end

return M
