return {
    "quarto-dev/quarto-nvim",
    dependencies = {
        "jmbuhr/otter.nvim",
        "benlubas/molten-nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown" },
    opts = {
        codeRunner = {
            enabled = true,
            default_method = "molten",
        },
    },
}
