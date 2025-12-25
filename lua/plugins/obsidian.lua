return {
  "obsidian-nvim/obsidian.nvim",
  cond = vim.g.vscode == nil,
  version = "*",
  -- Lazy loading: Only load on vault files or specific commands
  event = {
    "BufReadPre " .. vim.fn.expand "~" .. "/vaults/**.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/vaults/**.md",
  },
  cmd = {
    "Obsidian",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- Open vaults in floating terminal
    {
      "<leader>op",
      function()
        Snacks.terminal("nvim .", { cwd = vim.fn.expand "~/vaults/personal" })
      end,
      desc = "Open Personal Vault",
    },
    {
      "<leader>oh",
      function()
        Snacks.terminal("nvim .", { cwd = vim.fn.expand "~/vaults/htwk" })
      end,
      desc = "Open HTWK Vault",
    },
    {
      "<leader>ow",
      function()
        Snacks.terminal("nvim .", { cwd = vim.fn.expand "~/vaults/work" })
      end,
      desc = "Open Work Vault",
    },
    -- Obsidian shortcuts
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search" },
    { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "htwk",
        path = "~/vaults/htwk",
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
    },
  },
}
