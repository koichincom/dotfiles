local M = {}

local current_head = nil
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
