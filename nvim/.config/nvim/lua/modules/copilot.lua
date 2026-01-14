local M = {}

function M.update_winbar()
    local winbar = require("modules.winbar.main")
    local is_enabled = vim.fn["copilot#Enabled"]() == 1
    winbar.update_component("copilot", is_enabled)
end

function M.toggle()
    local is_enabled = vim.fn["copilot#Enabled"]() == 1
    if is_enabled then
        vim.cmd("Copilot disable")
    else
        vim.cmd("Copilot enable")
    end
    M.update_winbar()
end
return M
