local M = {}

function M.get_gh_copilot(is_enable)
    if is_enable then
        return { text = "", is_alert = false }
    else
        return { text = "ai-comp:off", is_alert = true }
    end
end

function M.get_wrap(is_enable)
    if is_enable then
        return { text = "wrap:on", is_alert = true }
    else
        return { text = "", is_alert = false }
    end
end

function M.get_auto_write(state)
    if state == "true" then
        return { text = "", is_alert = false }
    elseif state == "partial" then
        return { text = "save:partial", is_alert = true }
    else
        return { text = "save:off", is_alert = true }
    end
end

return M
