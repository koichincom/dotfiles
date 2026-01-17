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
                require("modules.gh-copilot").toggle()
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
        {
            "<C-L>",
            "<Plug>(copilot-next)",
            mode = "i",
            desc = "Copilot Next",
        },
        {
            "<C-H>",
            "<Plug>(copilot-previous)",
            mode = "i",
            desc = "Copilot Previous",
        },
        {
            "<C-K>",
            "<Plug>(copilot-accept-word)",
            mode = "i",
            desc = "Copilot Accept Word",
        },
    },
    config = function()
        require("core.autocmds").init_gh_copilot()
        require("modules.gh-copilot").update_winbar() -- Initialize winbar
    end,
}
