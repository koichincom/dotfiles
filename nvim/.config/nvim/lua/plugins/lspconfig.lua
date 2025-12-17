-- nvim-lspconfig: Provides baseline LSP server configurations
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason.nvim",
        "mason-lspconfig.nvim",
    },
    config = function()
        require("modules.lsp").init()
    end,
}
