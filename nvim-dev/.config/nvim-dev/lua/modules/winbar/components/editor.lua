local M = {}

function M.get_copilot(is_enable)
    if is_enable then
        return { text = "", is_alert = false }
    else
        return { text = "!C", is_alert = true }
    end
end

function M.get_wrap(is_enable)
    if is_enable then
        return { text = "W", is_alert = true }
    else
        return { text = "", is_alert = false }
    end
end

function M.get_auto_write(state)
    if state == "true" then
        return { text = "", is_alert = false }
    elseif state == "partial" then
        return { text = "s", is_alert = true }
    else
        return { text = "!S", is_alert = true }
    end
end

return M
