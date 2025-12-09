local M = {}

local current_head = nil

function M.get_cwd()
    local cwd = vim.fs.basename(vim.fn.getcwd())
    return cwd
end

function M.get_branch(from_focusgained)
    if vim.bo.buftype ~= "" then
        return ""
    end
    if current_head == nil or from_focusgained then
        current_head = vim.g.gitsigns_head
    end
    return current_head
end

return M