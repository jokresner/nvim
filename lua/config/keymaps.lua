-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Toggle alternate buffer" })

-- Copy path:line to clipboard
vim.keymap.set("n", "<leader>fl", function()
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
    local line = vim.fn.line(".")
    local value = path .. ":" .. line
    vim.fn.setreg("+", value)
    vim.notify("Copied " .. value)
end, { desc = "Copy path:line" })

-- Escape and clear search highlight
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Scroll centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
-- Diagnostics
vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Diagnostic line" })
vim.keymap.set("n", "<leader>n", function()
    vim.diagnostic.jump({ count = vim.v.count1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>N", function()
    vim.diagnostic.jump({ count = -vim.v.count1, float = true })
end, { desc = "Prev diagnostic" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Indent (keep selection)
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Clipboard
vim.keymap.set("n", "<leader>y", '"+yy', { desc = "Yank line to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("x", "<leader>P", '"_dP', { desc = "Paste keep register" })

-- Clear search highlight on Enter, or pass through
vim.keymap.set("n", "<CR>", function()
    if vim.v.hlsearch == 1 then
        vim.cmd.nohlsearch()
        return ""
    end
    return "<CR>"
end, { expr = true, desc = "Clear search or enter" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Window left" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Window down" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Window up" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Window right" })

-- Window resize
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window taller" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window shorter" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window narrower" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window wider" })

-- Treesitter/LSP incremental selection
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_parent(vim.v.count1)
    else
        vim.lsp.buf.selection_range(vim.v.count1)
    end
end, { desc = "Select parent node" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_child(vim.v.count1)
    else
        vim.lsp.buf.selection_range(-vim.v.count1)
    end
end, { desc = "Select child node" })
