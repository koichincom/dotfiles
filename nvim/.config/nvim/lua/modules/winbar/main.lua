local M = {}

local buffer = require("modules.winbar.components.buffer")
local editor = require("modules.winbar.components.editor")
local project = require("modules.winbar.components.project")

local components_map = {
    cwd = {
        state = "",
        getter = project.get_cwd,
    },
    diagnostics = {
        state = { errors = 0, warnings = 0 },
        getter = buffer.get_diagnostics,
    },
    git_branch = {
        state = "",
        getter = project.get_branch,
    },
    file_path_name = {
        state = {
            path = "",
            name = "",
        },
        getter = buffer.get_path_name,
    },
    encode = {
        state = { text = "", is_alert = false },
        getter = buffer.get_encode,
    },
    file_mod = {
        state = false,
        getter = buffer.get_file_mod,
    },
    wrap = {
        state = { text = "", is_alert = false },
        getter = editor.get_wrap,
    },
    gh_copilot = {
        state = { text = "", is_alert = false },
        getter = editor.get_gh_copilot,
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

    local diagnostics_parts = {}
    if cm.diagnostics.state.errors > 0 then
        table.insert(diagnostics_parts, "%#WinBarAlertRed#E:" .. cm.diagnostics.state.errors)
    end
    if cm.diagnostics.state.warnings > 0 then
        table.insert(diagnostics_parts, "%#WinBarAlertYellow#W:" .. cm.diagnostics.state.warnings)
    end
    local diagnostics_str = join(" ", diagnostics_parts)

    -- Left group: file path + name + diagnostics
    local left_group = table.concat({
        "%#WinBar#",
        cm.file_path_name.state.path,
        (cm.file_path_name.state.path ~= "" and cm.file_path_name.state.name ~= "") and "/" or "",
        cm.file_mod.state and "%#WinBarFileNameModified#" or "%#WinBarFileName#",
        cm.file_path_name.state.name,
        diagnostics_str ~= "" and " " or "",
        diagnostics_str,
    })

    -- Right group: flags + cwd + git branch
    local context = table.concat({
        "%#WinBar#",
        cm.cwd.state,
        (cm.cwd.state ~= "" and cm.git_branch.state ~= "") and ":" or "",
        cm.git_branch.state,
    })

    local flags = join(" ", {
        render_alert_component(cm.gh_copilot.state),
        render_alert_component(cm.wrap.state),
        render_alert_component(cm.auto_write.state),
        render_alert_component(cm.encode.state),
    })

    local right_group = join(" ", { flags, context })

    local winbar = table.concat({
        left_group ~= "" and " " or "",
        left_group,
        "%=",
        "%#WinBar#",
        right_group,
        right_group ~= "" and " " or "",
    })
    vim.wo.winbar = winbar
    -- vim.wo.statusline = winbar
end

local function is_states_equal(old, new)
    if type(old) ~= type(new) then
        return false
    end
    if type(old) == "table" then
        for k, v in pairs(old) do
            if new[k] ~= v then
                return false
            end
        end
        for k, v in pairs(new) do
            if old[k] ~= v then
                return false
            end
        end
        return true
    end
    return old == new
end

function M.update_component(component_name, params)
    local component_conf = components_map[component_name]
    if not component_conf then
        return
    end
    local state = component_conf.getter(params)

    -- Return if the component is unchanged, or state is nil
    if is_states_equal(component_conf.state, state) or (state == nil) then
        return
    end
    component_conf.state = state

    M.render()
end

return M
