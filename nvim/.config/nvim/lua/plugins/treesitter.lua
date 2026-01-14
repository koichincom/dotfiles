return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
}

-- `:checkhealth nvim-treesitter` to check the installed parsers
-- `TSInstall <language>` to install a parser, and avoided to use install Lua API
