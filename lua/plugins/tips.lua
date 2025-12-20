return {
  "saxon1964/neovim-tips",
  version = "*",
  lazy = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  opts = {
    daily_tip = 0, -- 0 = off, 1 = once per day, 2 = every startup
    bookmark_symbol = "🌟 ",
  },
  keys = {
    { "<leader>nt", ":NeovimTips<CR>", desc = "Show Neovim tips" },
  },
}
