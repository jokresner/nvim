local vaults_root = os.getenv("OBSIDIAN_VAULTS") or vim.fn.expand("~/vaults")

return {
  "obsidian-nvim/obsidian.nvim",
  cond = vim.g.vscode == nil,
  version = "*",
  -- Lazy loading: Only load on vault files or specific commands (set OBSIDIAN_VAULTS to override ~/vaults)
  event = {
    "BufReadPre " .. vaults_root .. "/**/*.md",
    "BufNewFile " .. vaults_root .. "/**/*.md",
  },
  cmd = {
    "Obsidian",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  keys = {
    -- Open vaults in floating terminal
    {
      "<leader>op",
      function()
        require("snacks").terminal("nvim .", {
          cwd = vaults_root .. "/personal",
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
        require("snacks").terminal("nvim .", {
          cwd = vaults_root .. "/htwk",
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
        require("snacks").terminal("nvim .", {
          cwd = vaults_root .. "/work",
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
        require("snacks").picker.select({ "personal", "htwk", "work" }, {
          prompt = "Select Vault",
        }, function(vault)
          if not vault then
            return
          end
          local daily_note = vaults_root .. "/" .. vault .. "/daily/" .. os.date("%d.%m.%Y") .. ".md"
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
  opts = function()
    return {
      legacy_commands = false, -- this will be removed in the next major release
      workspaces = {
        { name = "personal", path = vaults_root .. "/personal" },
        { name = "htwk", path = vaults_root .. "/htwk" },
        { name = "work", path = vaults_root .. "/work" },
      },
      daily_notes = {
        folder = "daily",
        date_format = "%d.%m.%Y",
      },
    }
  end,
}
