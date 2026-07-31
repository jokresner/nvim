-- Pre-seed background before colorscheme loads to avoid mocha flash in light mode
local bg_cache = vim.fn.stdpath("state") .. "/bg_state"
local f = io.open(bg_cache, "r")
if f then
    local bg = f:read("*a")
    f:close()
    if bg == "dark" or bg == "light" then
        vim.o.background = bg
    end
end

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.autowrite = true
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.signcolumn = "yes:2"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.undofile = true
opt.updatetime = 200

-- Performance & Providers (Disable unused language hosts)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

opt.shada = { "'10", "<0", "s10", "h" }

-- UI & Visual Feedback
opt.inccommand = "split"
opt.laststatus = 3
opt.timeoutlen = 300
opt.sidescrolloff = 8
opt.conceallevel = 1
opt.pumheight = 10
opt.pumblend = 10

-- Text Editing Ergonomics
opt.wrap = true
opt.linebreak = true
opt.swapfile = false

-- Remove comment continuation on 'o'/'O'
-- Placed in an autocmd so FileType plugins don't overwrite it.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove("c")
        vim.opt.formatoptions:remove("r")
        vim.opt.formatoptions:remove("o")
    end,
})
