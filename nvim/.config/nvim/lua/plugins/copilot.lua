return {
    "github/copilot.vim",
    lazy = false,
    init = function()
        vim.g.copilot_no_tab_map = true -- Disable default <Tab> mapping
    end,
    keys = {
        {
            "<leader>tc",
            function()
                require("modules.copilot").toggle()
            end,
            desc = "Toggle Copilot",
        },
        {
            "<C-J>",
            'copilot#Accept("<CR>")',
            mode = "i",
            expr = true,
            silent = true,
            replace_keycodes = false,
            desc = "Copilot Accept",
        },
    },
    config = function()
        require("core.autocmds").init_copilot()
        require("modules.copilot").update_winbar() -- Initialize winbar
    end,
}
