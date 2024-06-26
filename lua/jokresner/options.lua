-- enable autoformat
vim.g.autoformat = true

-- setup completion promt
vim.opt.completeopt = "menu,menuone,preview,noinsert,noselect"

-- setup numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- enable mouse mode
vim.opt.mouse = "a"

-- setup tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- show invisible characters
vim.opt.list = true

-- disable showmode because of statusline
vim.opt.showmode = false

-- smart options
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.ignorecase = true

-- beautify
vim.opt.signcolumn = "yes"

-- shorter update
vim.opt.updatetime = 200
