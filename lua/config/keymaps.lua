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

-- Zellij
-- 1. Cache the OUTER environment variables instantly on boot.
-- This grabs the socket path of your main Zellij window before Sidekick can mask it.
local z_session = vim.env.ZELLIJ_SESSION
local z_socket = vim.env.ZELLIJ

-- 2. Define globally as _G so the Terminal maps (:lua) can actually see and execute it!
_G.zellij_navigate = function(direction)
  local current_win = vim.api.nvim_get_current_win()
  local is_terminal = vim.bo.buftype == "terminal"

  -- Attempt to move within Neovim
  vim.cmd("wincmd " .. direction)

  -- If window didn't change, we are at the edge
  if current_win == vim.api.nvim_get_current_win() then
    local zellij_direction = ({ h = "left", j = "down", k = "up", l = "right" })[direction]

    -- Safely build the system command, forcing the outer Zellij environment variables
    local cmd = { "env" }
    if z_socket then
      table.insert(cmd, "ZELLIJ=" .. z_socket)
    end
    if z_session then
      table.insert(cmd, "ZELLIJ_SESSION=" .. z_session)
    end

    table.insert(cmd, "zellij")
    table.insert(cmd, "action")
    table.insert(cmd, "move-focus-or-tab")
    table.insert(cmd, zellij_direction)

    -- Execute the move
    vim.fn.system(cmd)

    -- If we initiated this from the Sidekick terminal, smoothly go back to insert mode.
    -- A tiny 50ms delay prevents Neovim from stealing focus back before Zellij moves.
    if is_terminal then
      vim.defer_fn(function()
        vim.cmd "startinsert"
      end, 50)
    end
  end
end

-- Normal Mode Mappings
vim.keymap.set("n", "<C-h>", function()
  _G.zellij_navigate "h"
end, { silent = true })
vim.keymap.set("n", "<C-j>", function()
  _G.zellij_navigate "j"
end, { silent = true })
vim.keymap.set("n", "<C-k>", function()
  _G.zellij_navigate "k"
end, { silent = true })
vim.keymap.set("n", "<C-l>", function()
  _G.zellij_navigate "l"
end, { silent = true })

-- Terminal Mode Mappings (crucial for sidekick.nvim)
vim.keymap.set("t", "<C-h>", [[<C-\><C-n>:lua _G.zellij_navigate('h')<CR>]], { silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n>:lua _G.zellij_navigate('j')<CR>]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n>:lua _G.zellij_navigate('k')<CR>]], { silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:lua _G.zellij_navigate('l')<CR>]], { silent = true })
