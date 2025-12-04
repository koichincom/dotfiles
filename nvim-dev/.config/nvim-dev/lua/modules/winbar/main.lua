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

local function render()
    local cm = components_map

    local center_group = join(" ", {
        cm.encode.state,
        cm.file_mod.state,
        cm.diagnostics.state,
    })

    local right_group = join(" ", {
        cm.copilot.state,
        cm.wrap.state,
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

local render_pending = false
local function render_scheduled()
    if render_pending then
        return
    end
    render_pending = true
    vim.schedule(function()
        render()
        render_pending = false
    end)
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

    -- Skip render for special buffers (buftype ~= "")
    if vim.bo.buftype ~= "" then
        return
    end
    render_scheduled()
end

return M
