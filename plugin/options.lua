vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

local opt = vim.opt

opt.inccommand = "split"

opt.smartcase = true
opt.ignorecase = true

opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

opt.swapfile = false

-- Don't have `o` add a comment
opt.formatoptions:remove "o"

opt.wrap = true
opt.linebreak = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.more = false

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

opt.undofile = true

opt.pumblend = 10 -- Popup menu transparency
opt.pumheight = 10 -- Max popup menu height
opt.scrolloff = 8 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.cursorline = true -- Highlight current line
opt.cmdheight = 1 -- Command line height
opt.laststatus = 3 -- Global statusline
opt.updatetime = 250 -- Faster CursorHold
opt.timeoutlen = 300 -- Faster which-key popup
