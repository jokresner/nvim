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

-- Clipboard copy and paste
set("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
set("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
set("v", "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Better window resizing
set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting (stay in visual mode)
set("v", "<", "<gv", { desc = "Indent left" })
set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down in visual mode
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when scrolling
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Better paste in visual mode (don't yank replaced text)
set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Quick save
set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

set("n", "<leader>lu", "<Cmd>noh<CR>", { desc = "Clear search highlight" })
