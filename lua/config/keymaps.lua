local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window taller" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window shorter" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window wider" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit window" })

map("n", "<leader>y", '"+yy', { desc = "Yank line to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("x", "<leader>P", '"_dP', { desc = "Paste keep register" })

map("n", "<leader>uh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>uu", function()
  vim.cmd.packadd "nvim.undotree"
  vim.cmd.Undotree()
end, { desc = "Undo tree" })

-- Ergonomic navigation for QWERTZ ([ / ] are AltGr+8/9)
map("n", "<leader>n", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>N", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

map("n", "<leader>utc", "<cmd>ContextModeToggle<cr>", { desc = "Toggle context mode" })
map("n", "<leader>uta", "<cmd>ContextModeAuto<cr>", { desc = "Auto context mode" })

map("n", "<leader>cl", function()
  local path = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.")
  local line = vim.fn.line "."
  local value = path .. ":" .. line
  vim.fn.setreg("+", value)
  vim.notify("Copied " .. value)
end, { desc = "Copy path:line" })

map("n", "<CR>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohlsearch()
    return ""
  end
  return "<CR>"
end, { expr = true, desc = "Clear search or enter" })

-- incremental selection treesitter/lsp
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })
