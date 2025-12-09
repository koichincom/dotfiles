local M = {}

-- Store last_full_path to avoid unnecessary computation
local last_full_path = nil

function M.get_path_name()
    local full_path = vim.fs.normalize(vim.fn.expand("%:p"))
    if full_path == last_full_path then
        return nil
    end
    last_full_path = full_path
    local file_path, file_name = "", ""

    -- Handle oil.nvim directory buffers
    if vim.startswith(full_path, "oil:/") or full_path == "oil:" then
        full_path = vim.fs.normalize(require("oil").get_current_dir())
        if full_path ~= vim.fs.normalize(vim.fn.getcwd()) then
            file_path = vim.fn.fnamemodify(full_path, ":.")
        end
    else
        -- Normal file buffers
        full_path = vim.fn.fnamemodify(full_path, ":.")
        file_path = vim.fn.fnamemodify(full_path, ":h")
        file_path = file_path:gsub("^%.$", "")
        file_name = vim.fn.fnamemodify(full_path, ":t")
    end

    -- Normalize display
    if string.sub(file_path, 1, 1) == "/" then
        file_path = string.sub(file_path, 2, #file_path)
    end
    if string.sub(file_path, #file_path, #file_path) == "/" then
        file_path = string.sub(file_path, 1, #file_path - 1)
    end

    if string.sub(file_name, 1, 1) == "/" then
        file_name = string.sub(file_name, 2, #file_name)
    end
    if string.sub(file_name, #file_name, #file_name) == "/" then
        file_name = string.sub(file_name, 1, #file_name - 1)
    end
    return { path = file_path, name = file_name }
end

function M.get_encode()
    if vim.bo.buftype ~= "" then
        return nil
    end
    local encode = (vim.bo.fileencoding or ""):lower()
    if encode ~= "utf-8" and encode ~= "" then
        return encode
    else
        return nil
    end
end

function M.get_file_mod()
    if vim.bo.buftype ~= "" then
        return nil
    end
    if vim.bo.modified then
        return "M"
    else
        return ""
    end
end

return M
