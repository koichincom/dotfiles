local M = {}

function M.get_copilot(is_enable)
    if is_enable then
        return ""
    else
        return "!C"
    end
end

function M.get_wrap(is_enable)
    if is_enable then
        return "W"
    else
        return ""
    end
end

function M.get_cwd()
    local cwd = vim.fs.basename(vim.fn.getcwd())
    return cwd
end

function M.get_auto_write(state)
    if state == "true" then
        return ""
    elseif state == "partial" then
        return "s"
    else
        return "!S"
    end
end

return M
