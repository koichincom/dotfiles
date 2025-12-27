-- nvim-treesitter: Parser management and syntax queries
-- API updated for nvim-treesitter main branch (Dec 2025)
-- See: https://github.com/nvim-treesitter/nvim-treesitter
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
        -- Install parsers only during plugin build/update, not on every startup
        require("nvim-treesitter").install({
            "astro",
            "bash",
            "c",
            "cpp",
            "csv",
            "css",
            "glsl",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "r",
            "sql",
            "toml",
            "tsx",
            "typescript",
            "tsv",
            "xml",
            "yaml",
            "zig",
        })
    end,
    config = function()
        -- Enable treesitter-based syntax highlighting for all supported filetypes
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
