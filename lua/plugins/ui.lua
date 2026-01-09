return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.ui").catppuccin
    end,
    config = function()
      --vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "oskarnurm/koda.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("koda").setup { transparent = true }
      vim.cmd "colorscheme koda"
    end,
  },
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      require("config.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    "stevearc/dressing.nvim",
    cmd = { "DressingSelect" },
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.ui").dressing
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.ui").which_key
    end,
  },
  {
    "jghauser/fold-cycle.nvim",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.ui").fold_cycle
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    cond = vim.g.vscode == nil,
    ft = "help",
  },
  {
    "nvim-mini/mini.indentscope",
    version = false,
    cond = vim.g.vscode == nil,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require("config.ui").indentscope
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "lazy", "mason", "snacks_picker" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.hipatterns",
    version = false,
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    opts = function()
      return require("config.ui").hipatterns()
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    opts = function()
      return require("config.ui").statuscol()
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    config = function()
      require("hlslens").setup()
      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap(
        "n",
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.api.nvim_set_keymap(
        "n",
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "<leader>lu", "<Cmd>noh<CR>", kopts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    cond = vim.g.vscode == nil,
    event = "LspAttach",
    opts = function()
      return require("config.ui").fidget
    end,
  },
  {
    "dgagn/diagflow.nvim",
    cond = vim.g.vscode == nil,
    event = "LspAttach",
    opts = function()
      return require("config.ui").diagflow
    end,
  },
  {
    "folke/noice.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = function()
      return require("config.ui").noice
    end,
    keys = {
      {
        "<leader>un",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>uN",
        function()
          require("noice").cmd "all"
        end,
        desc = "Notifications",
      },
    },
  },
  {
    "oribarilan/lensline.nvim",
    tag = "1.1.2", -- or: branch = 'release/1.x' for latest non-breaking updates
    event = "LspAttach",
    config = function()
      require("lensline").setup()
    end,
  },
  {
    "nvim-mini/mini.starter",
    cond = vim.g.vscode == nil,
    event = "VimEnter",
    opts = function()
      return require("config.ui").starter
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "gisketch/triforce.nvim",
    dependencies = { "nvzone/volt" },
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = {
      keymap = {
        show_profile = "<leader>up",
      },
    },
  },
}
