vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- Pre-seed background before colorscheme loads to avoid mocha flash in light mode
do
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    vim.o.background = result:match("Dark") and "dark" or "light"
  end
end

vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto:2"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.whichwrap:append("<,>,h,l")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.shada = { "'10", "<0", "s10", "h" }

vim.opt.laststatus = 3
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.conceallevel = 1

vim.opt.foldmethod = "manual"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.formatoptions:remove("o")

-- Add Mason bin directory to the Neovim's PATH
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end
