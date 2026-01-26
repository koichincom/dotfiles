return {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
        -- example options
        timeout = 3000,
        -- ... other options
    },
    config = function(_, opts)
        local notify = require("notify")
        notify.setup(opts)
        vim.notify = notify
    end,
}
