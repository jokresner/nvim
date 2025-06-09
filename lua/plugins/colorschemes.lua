return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
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
}
