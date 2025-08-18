return {
  "folke/noice.nvim",
  event = "VeryLazy",
  cond = vim.g.vscode == nil,
  opts = {
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  keys = {
    {
      "<leader>n",
      function()
        require("noice").cmd("dismiss")
      end,
      desc = "Dismiss Notification",
    },
    {
      "<leader>N",
      function()
        require("noice").cmd("last")
      end,
      desc = "Show Last Notification",
    },
  },
}
