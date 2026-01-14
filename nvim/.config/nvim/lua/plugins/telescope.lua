return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        "debugloop/telescope-undo.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        require("telescope").setup({
            extensions = {
                fzf = {},
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({}),
                },
                ["live-grep-args"] = {},
                undo = {},
            },
        })
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("live_grep_args")
        require("telescope").load_extension("undo")

        local opts = { noremap = true, silent = true }
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts)
        vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
        vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", opts)
    end,
}
