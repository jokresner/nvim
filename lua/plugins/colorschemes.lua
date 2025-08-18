return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    cond = vim.g.vscode == nil,
    opts = {
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        overseer = true,
      },
      background = {
        light = "latte",
        dark = "mocha",
      },
    },
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    cond = vim.g.vscode == nil,
    opts = {
      transparent = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },

  -- Auto dark mode plugin
  {
    "f-person/auto-dark-mode.nvim",
    enabled = false,
    config = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
      end,
    },
  },
}
