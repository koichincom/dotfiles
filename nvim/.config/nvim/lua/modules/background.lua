local M = {}

local highlight = require("modules.highlight.main")
local colorscheme = require("modules.colorscheme")

local last_os_theme
local function get_updated_theme()
    local theme
    local uname = vim.loop.os_uname().sysname

    if uname == "Darwin" then
        -- macOS: Use defaults command to read AppleInterfaceStyle
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if handle then
            local result = handle:read("*a")
            handle:close()
            result = result:gsub("%s+", "")
            if result == "" or result:lower() ~= "dark" then
                theme = "light"
            else
                theme = "dark"
            end
        end
    else
        -- Linux: Use gsettings to read GTK/GNOME color-scheme
        local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
        if handle then
            local result = handle:read("*a")
            handle:close()
            result = result:gsub("%s+", ""):gsub("'", "")
            if result == "prefer-dark" then
                theme = "dark"
            elseif result == "prefer-light" or result == "default" then
                theme = "light"
            end
        end
    end

    -- Fallback if detection failed
    if not theme then
        return nil
    end

    -- Validate and check for changes
    if theme ~= "light" and theme ~= "dark" then
        vim.notify("Unknown OS theme: " .. theme, vim.log.levels.WARN)
        return nil
    elseif theme == last_os_theme then
        return nil
    else
        last_os_theme = theme
        return theme
    end
end

function M.update()
    local theme = get_updated_theme()
    if theme == nil then
        return -- No change
    elseif theme == "light" then
        colorscheme.set_light()
        highlight.switch_namespace(nil, true, nil, false)
    else
        colorscheme.set_dark()
        highlight.switch_namespace(nil, false, nil, false)
    end

    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
        devicons.refresh()
    end
end

return M
