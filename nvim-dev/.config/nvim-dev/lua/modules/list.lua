local M = {}

function M.update_leadmultispace()
    local shiftwidth = vim.bo.shiftwidth
    vim.notify("Updating leadmultispace to shiftwidth: " .. shiftwidth, vim.log.levels.DEBUG)
    local leadmultispace = "┃"
    for _ = 1, (shiftwidth - 1) do -- (-1) since the first '│' is already added
        leadmultispace = leadmultispace .. " "
    end
    vim.opt.listchars:append({ leadmultispace = leadmultispace })
end

return M
