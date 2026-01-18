return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local autocmds = require("core.autocmds")
        autocmds.init_treesitter()
    end,
}

-- `:checkhealth nvim-treesitter` to check the installed parsers
-- `TSInstall <language>` to install a parser, and avoided to use install Lua API
-- Highlighting is enabled via autocmd in core/autocmds.lua
