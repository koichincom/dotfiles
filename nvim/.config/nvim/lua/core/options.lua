-- User Interface
-- vim.o.background = "light" -- This will be used before Neovim sets based on the terminal background
vim.opt.termguicolors = true -- Enable true color support (16 million colors)
vim.opt.laststatus = 0 -- Hide status line in favor of using winbar and noice.nvim
vim.opt.title = true -- Set terminal title
vim.opt.titlelen = 0 -- No limit on title length
vim.opt.titlestring = "Neovim" -- Set title to Neovim in the terminal titlebar
vim.wo.number = true -- Show absolute line numbers
vim.wo.relativenumber = true -- Show relative line numbers for easier navigation
vim.wo.signcolumn = "yes" -- Always show sign column to prevent text shifting
vim.wo.colorcolumn = "80" -- Highlight 80-column limit

-- Indentation
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.autoindent = true
vim.o.shiftround = true
vim.o.breakindent = true

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste

-- Search
vim.opt.ignorecase = true -- Case-insensitive search by default
vim.opt.smartcase = true -- Case-sensitive if search contains uppercase
vim.o.scrolloff = 8 -- Keep 4 lines visible above/below cursor

-- File
vim.o.autowriteall = true -- Auto-save before buffer switch/quit
vim.o.hidden = false -- Do not allow unsaved buffers in the background works with autowriteall

-- Window Management
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below

vim.wo.linebreak = true -- Wrap lines at convenient points (always true)

vim.wo.list = true
vim.opt.listchars = {
    -- leadmultispace = "├···",
    -- follow the default shiftwidth, but updated with .editorconfig by module/list.lua
    tab = ">·",
    space = "·",
    trail = "+",
    extends = "»",
    precedes = "«",
}
vim.wo.cursorline = true
vim.g.mapleader = " "
vim.o.undofile = true
vim.o.autoread = true
