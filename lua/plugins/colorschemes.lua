return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    vscode = false,
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
}
