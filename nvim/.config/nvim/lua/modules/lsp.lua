local M = {}

function M.init()
    -- Server-specific settings
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    })

    -- Enable LSP servers
    vim.lsp.enable({
        "lua_ls",
        "pyright",
        "ts_ls",
        "clangd",
        "html",
        "cssls",
        "jsonls",
        "astro",
        "glsl_analyzer",
        "zls",
    })

    -- LSP navigation keymaps (Telescope integration)
    local telescope_builtin = require("telescope.builtin")

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { desc = "Go to definition" })
    vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, { desc = "Go to type definition" })
    vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, { desc = "Go to implementation" })
    vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { desc = "Find references" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
end

return M
