local M = {}

local diagnostics = require("modules.winbar.components.diagnostics")
local git = require("modules.winbar.components.git")
local file = require("modules.winbar.components.file")
local editor = require("modules.winbar.components.editor")

local components_map = {
    cwd = {
        state = "",
        getter = editor.get_cwd,
    },
    diagnostics = {
        state = "",
        getter = diagnostics.get_diagnostics,
    },
    git_branch = {
        state = "",
        getter = git.get_branch,
    },
    file_path_name = {
        state = {
            path = "",
            name = "",
        },
        getter = file.get_path_name,
    },
    encode = {
        state = "",
        getter = file.get_encode,
    },
    file_mod = {
        state = "",
        getter = file.get_file_mod,
    },
    wrap = {
        state = "",
        getter = editor.get_wrap,
    },
    copilot = {
        state = "",
        getter = editor.get_copilot,
    },
    auto_write = {
        state = "",
        getter = editor.get_auto_write,
    },
}

local function join(delimiter, list)
    local result = {}
    for _, item in ipairs(list) do
        if item and item ~= "" then
            table.insert(result, item)
        end
    end
    return table.concat(result, delimiter)
end

function M.render()
    -- Skip render for special buffers, except Oil
    if vim.bo.buftype ~= "" and vim.bo.filetype ~= "oil" then
        return
    end
    local cm = components_map

    local center_group = join(" ", {
        cm.encode.state,
        cm.file_mod.state,
        cm.diagnostics.state,
    })

    local right_group = join(" ", {
        cm.copilot.state,
        cm.wrap.state,
        cm.auto_write.state,
    })

    local winbar = table.concat({
        "%#WinBar#",
        " ",
        cm.cwd.state,
        (cm.cwd.state ~= "" and cm.git_branch.state ~= "") and ":" or "",
        cm.git_branch.state,

        "%=",
        cm.file_path_name.state.path,
        (cm.file_path_name.state.path ~= "" and cm.file_path_name.state.name ~= "") and "/" or "",
        "%#WinBarFileName#",
        cm.file_path_name.state.name,
        "%#WinBarAlert#",

        -- Add space only if center_group has content just in case
        (center_group ~= "") and " " or "",
        center_group,

        "%=",
        "%#WinBar#",
        right_group,
        " ",
    })
    vim.wo.winbar = winbar
end

function M.update_component(component_name, params)
    local component_conf = components_map[component_name]
    if not component_conf then
        return
    end
    local state = component_conf.getter(params)

    -- Return if the component is unchanged, or state is nil
    if (component_conf.state == state) or (state == nil) then
        return
    end
    component_conf.state = state

    M.render()
end

return M
