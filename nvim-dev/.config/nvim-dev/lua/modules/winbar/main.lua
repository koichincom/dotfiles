local M = {}

local file = require("modules.winbar.components.file")
local editor = require("modules.winbar.components.editor")
local workspace = require("modules.winbar.components.workspace")

local components_map = {
    cwd = {
        state = "",
        getter = workspace.get_cwd,
    },
    diagnostics = {
        state = "",
        getter = file.get_diagnostics,
    },
    git_branch = {
        state = "",
        getter = workspace.get_branch,
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
        state = false,
        getter = file.get_file_mod,
    },
    wrap = {
        state = { text = "", is_alert = false },
        getter = editor.get_wrap,
    },
    copilot = {
        state = { text = "", is_alert = false },
        getter = editor.get_copilot,
    },
    auto_write = {
        state = { text = "", is_alert = false },
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

local function render_alert_component(component)
    if type(component) == "table" then
        if component.text == "" then
            return ""
        end
        local hl = component.is_alert and "%#WinBarAlertRed#" or "%#WinBar#"
        return hl .. component.text
    else
        return component
    end
end

function M.render()
    -- Skip render for special buffers, except Oil
    if vim.bo.buftype ~= "" and vim.bo.filetype ~= "oil" then
        return
    end
    local cm = components_map

    local center_group = join(" ", {
        cm.encode.state,
        cm.diagnostics.state,
    })

    local right_parts = {
        render_alert_component(cm.copilot.state),
        render_alert_component(cm.wrap.state),
        render_alert_component(cm.auto_write.state),
    }
    local right_group = join(" ", right_parts)

    local winbar = table.concat({
        "%#WinBar#",
        " ",
        cm.cwd.state,
        (cm.cwd.state ~= "" and cm.git_branch.state ~= "") and ":" or "",
        cm.git_branch.state,

        "%=",
        cm.file_path_name.state.path,
        (cm.file_path_name.state.path ~= "" and cm.file_path_name.state.name ~= "") and "/" or "",
        cm.file_mod.state and "%#WinBarFileNameModified#" or "%#WinBarFileName#",
        cm.file_path_name.state.name .. (cm.file_mod.state and "+" or ""),
        "%#WinBarAlert#",

        (center_group ~= "") and " " or "",
        center_group,

        "%=",
        right_group,
        right_group ~= "" and " " or "",
    })
    vim.wo.winbar = winbar
end

local function states_equal(a, b)
    if type(a) ~= type(b) then
        return false
    end
    if type(a) == "table" then
        for k, v in pairs(a) do
            if b[k] ~= v then
                return false
            end
        end
        for k, v in pairs(b) do
            if a[k] ~= v then
                return false
            end
        end
        return true
    end
    return a == b
end

function M.update_component(component_name, params)
    local component_conf = components_map[component_name]
    if not component_conf then
        return
    end
    local state = component_conf.getter(params)

    -- Return if the component is unchanged, or state is nil
    if states_equal(component_conf.state, state) or (state == nil) then
        return
    end
    component_conf.state = state

    M.render()
end

return M
