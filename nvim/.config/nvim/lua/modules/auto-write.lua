local M = {}

local winbar = nil
local is_enabled = nil

function M.update_status()
    if vim.o.autowriteall == true then
        is_enabled = "true"
        vim.o.hidden = false
    else
        vim.o.hidden = true
        if vim.o.autowrite == true then
            is_enabled = "partial"
        else
            is_enabled = "false"
        end
    end

    if winbar == nil then
        winbar = require("modules.winbar.main")
    end
    winbar.update_component("auto_write", is_enabled)
end

function M.update_hidden()
    if vim.o.hidden == true then
        vim.o.autowriteall = false
    else
        vim.o.autowriteall = true
    end
    M.update_status()
end

local function toggle()
    if is_enabled == "true" or is_enabled == "partial" then
        vim.o.autowriteall = false
        vim.o.hidden = true
    else
        vim.o.autowriteall = true
        vim.o.hidden = false
    end
    M.update_status()
end

function M.write()
    if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.modified and is_enabled then
        vim.cmd("silent! update")
        return true
    end
    return false
end

vim.keymap.set("n", "<leader>ts", toggle, { desc = "Toggle Auto Write" })

return M
