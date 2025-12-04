local M = {}

function M.get_diagnostics()
    -- Hide diagnostics for special buffers
    if vim.bo.buftype ~= "" then
        return ""
    end

    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 0 then
        return "E:" .. #diagnostics
    else
        return ""
    end
end

return M
