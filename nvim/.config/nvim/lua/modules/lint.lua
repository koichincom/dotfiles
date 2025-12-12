local M = {}

local lint = nil
local auto_write = nil

-- Languages that stdin compatible linters are used in this config
local stdin_compatibility = {
    python = true,
    lua = true,
    javascript = true,
    typescript = true,
    c = true,
    cpp = true,
    html = true,
    css = true,
    markdown = true,
    json = true,
}

-- nvim-lint's try_lint() doesn't take the buffer anyway
function M.main(autocmd_event)
    if lint == nil then
        lint = require("lint")
    end

    if stdin_compatibility[vim.bo.filetype] == nil then
        -- No linter is set for this filetype
        return
    elseif stdin_compatibility[vim.bo.filetype] then
        lint.try_lint()
        return
    end

    if autocmd_event == "BufWritePost" then
        lint.try_lint()
    elseif autocmd_event == "BufEnter" then
        if auto_write == nil then
            auto_write = require("modules.auto_write")
        end
        local was_written = auto_write.write()
        if was_written then
            lint.try_lint()
        end
    end
end

return M
