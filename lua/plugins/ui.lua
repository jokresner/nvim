return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    cond = vim.g.vscode == nil,
    config = function()
      require("catppuccin").setup(require("config.ui").catppuccin)
      vim.cmd.colorscheme "catppuccin"
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
  {
    "TheNoeTrevino/haunt.nvim",
    -- default config: change to your liking, or remove it to use defaults
    ---@class HauntConfig
    opts = {
      sign = "󱙝",
      sign_hl = "DiagnosticInfo",
      virt_text_hl = "HauntAnnotation",
      annotation_prefix = " 󰆉 ",
      line_hl = nil,
      virt_text_pos = "eol",
      data_dir = nil,
      picker_keys = {
        delete = { key = "d", mode = { "n" } },
        edit_annotation = { key = "a", mode = { "n" } },
      },
    },
    -- recommended keymaps, with a helpful prefix alias
    init = function()
      local haunt = require "haunt.api"
      local haunt_picker = require "haunt.picker"
      local map = vim.keymap.set
      local prefix = "<leader>h"

      -- annotations
      map("n", prefix .. "a", function()
        haunt.annotate()
      end, { desc = "Annotate" })

      map("n", prefix .. "t", function()
        haunt.toggle_annotation()
      end, { desc = "Toggle annotation" })

      map("n", prefix .. "T", function()
        haunt.toggle_all_lines()
      end, { desc = "Toggle all annotations" })

      map("n", prefix .. "d", function()
        haunt.delete()
      end, { desc = "Delete bookmark" })

      map("n", prefix .. "C", function()
        haunt.clear_all()
      end, { desc = "Delete all bookmarks" })

      -- move
      map("n", prefix .. "p", function()
        haunt.prev()
      end, { desc = "Previous bookmark" })

      map("n", prefix .. "n", function()
        haunt.next()
      end, { desc = "Next bookmark" })

      -- picker
      map("n", prefix .. "l", function()
        haunt_picker.show()
      end, { desc = "Show Picker" })

      -- quickfix
      map("n", prefix .. "q", function()
        haunt.to_quickfix()
      end, { desc = "Show Picker" })

      map("n", prefix .. "Q", function()
        haunt.to_quickfix { current_buffer = true }
      end, { desc = "Show Picker" })

      -- yank
      map("n", prefix .. "y", function()
        haunt.yank_locations { current_buffer = true }
      end, { desc = "Show Picker" })

      map("n", prefix .. "Y", function()
        haunt.yank_locations()
      end, { desc = "Show Picker" })
    end,
  },
}
