return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'github/copilot.vim',

  {
    'folke/which-key.nvim',
    opts = {
      plugins = {
        spelling = true
      },
    },
    config = function()
      -- document existing key chains
      local wk = require("which-key")
      wk.add({
        { "<leader>c",  group = "[C]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d",  group = "[D]ebug" },
        { "<leader>d_", hidden = true },
        { "<leader>g",  group = "[G]it" },
        { "<leader>g_", hidden = true },
        { "<leader>h",  group = "Git [H]unk" },
        { "<leader>h_", hidden = true },
        { "<leader>r",  group = "[R]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>s",  group = "[S]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t",  group = "[T]oggle" },
        { "<leader>t_", hidden = true },
        { "<leader>w",  group = "[W]orkspace" },
        { "<leader>w_", hidden = true },
      })
    end,
  },

  { 'echasnovski/mini.nvim',   version = false },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    'stevearc/dressing.nvim',
    opts = nil,
  },

  { "nvim-lua/plenary.nvim",   lazy = true },

  { "ThePrimeagen/vim-be-good" },

  {
    "lukas-reineke/headlines.nvim",
    config = true,
  }

}
