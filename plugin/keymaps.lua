local set = vim.keymap.set

set("i", "jj", "<Esc>", { noremap = true, silent = true })
set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Basic movement keybinds, these make navigating splits easy
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

--set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source the current file" })

-- Toggle hlsearch if it's on, otherwise just do "enter"
set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.hlsearch:get() then
    vim.cmd.nohl()
    return ""
  else
    return "<CR>"
  end
end, { expr = true })

set("n", "<space>tt", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end)

set("n", "<C-u>", "<C-u>zz", { silent = true })
set("n", "<C-d>", "<C-d>zz", { silent = true })
