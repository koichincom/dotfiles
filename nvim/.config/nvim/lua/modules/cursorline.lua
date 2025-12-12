local M = {}

local is_enabled = true

function M.turn_on()
    if is_enabled then
        return
    end
    vim.wo.cursorline = true
    is_enabled = true
end

function M.turn_off()
    if not is_enabled then
        return
    end
    vim.wo.cursorline = false
    is_enabled = false
end

local function toggle()
    if is_enabled then
        M.turn_off()
    else
        M.turn_on()
    end
end

vim.keymap.set("n", "<leader>tl", toggle, { desc = "Toggle Cursorline" })

return M
