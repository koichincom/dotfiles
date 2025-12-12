return {
    "stevearc/oil.nvim",
    lazy = false, -- To hijack netrw on startup without troubles
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "-",
            function()
                require("oil").open(nil, {
                    preview = {},
                })
            end,
            desc = "Open the parent directory",
        },
    },
    opts = {
        delete_to_trash = true,
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name)
                return name == ".." or name == ".DS_Store"
            end,
        },
    },
}
