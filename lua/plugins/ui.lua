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
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.ui").kanagawa
    end,
  },
  {
    "echasnovski/mini.icons",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      require("config.icons").setup()
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
    "echasnovski/mini.clue",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      local conf = require("config.ui").clue()
      require("mini.clue").setup(conf.setup)
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
    "echasnovski/mini.indentscope",
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
    "echasnovski/mini.hipatterns",
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
    "b0o/incline.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
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
          require("noice").cmd "last"
        end,
        desc = "Last Notification",
      },
    },
  },
  {
    "anuvyklack/pretty-fold.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    config = function()
      require("pretty-fold").setup()
    end,
  },
}
