local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }, opts)

vim.keymap.set("n", "<C-q>", "<cmd> wqa! <CR>", opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
