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
        Snacks.terminal("nvim .", {
          cwd = vim.fn.expand "~/vaults/personal",
          on_close = function()
            -- Check if we are back in the main nvim instance and if it's empty
            if #vim.api.nvim_list_wins() == 1 then
              local buf = vim.api.nvim_get_current_buf()
              local name = vim.api.nvim_buf_get_name(buf)
              local type = vim.bo[buf].buftype
              local modified = vim.bo[buf].modified
              if name == "" and type == "" and not modified then
                vim.cmd "quit"
              end
            end
          end,
        })
      end,
      desc = "Open Personal Vault",
    },
    {
      "<leader>oh",
      function()
        Snacks.terminal("nvim .", {
          cwd = vim.fn.expand "~/vaults/htwk",
          on_close = function()
            if #vim.api.nvim_list_wins() == 1 then
              local buf = vim.api.nvim_get_current_buf()
              local name = vim.api.nvim_buf_get_name(buf)
              local type = vim.bo[buf].buftype
              local modified = vim.bo[buf].modified
              if name == "" and type == "" and not modified then
                vim.cmd "quit"
              end
            end
          end,
        })
      end,
      desc = "Open HTWK Vault",
    },
    {
      "<leader>ow",
      function()
        Snacks.terminal("nvim .", {
          cwd = vim.fn.expand "~/vaults/work",
          on_close = function()
            if #vim.api.nvim_list_wins() == 1 then
              local buf = vim.api.nvim_get_current_buf()
              local name = vim.api.nvim_buf_get_name(buf)
              local type = vim.bo[buf].buftype
              local modified = vim.bo[buf].modified
              if name == "" and type == "" and not modified then
                vim.cmd "quit"
              end
            end
          end,
        })
      end,
      desc = "Open Work Vault",
    },
    -- Obsidian shortcuts
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search" },
    { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
    {
      "<leader>oo",
      function()
        Snacks.picker.select({ "personal", "htwk", "work" }, {
          prompt = "Select Vault",
        }, function(vault)
          if not vault then
            return
          end
          local daily_note = vim.fn.expand("~/vaults/" .. vault .. "/daily/" .. os.date "%d.%m.%Y" .. ".md")
          -- Create dir if not exists
          vim.fn.mkdir(vim.fn.fnamemodify(daily_note, ":h"), "p")
          -- Open in vsplit
          vim.cmd("vsplit " .. daily_note)
        end)
      end,
      desc = "Open Daily Note (Split)",
    },
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
    daily_notes = {
      folder = "daily",
      date_format = "%d.%m.%Y",
    },
  },
}
