return {
  {
    "L3MON4D3/LuaSnip",
    cond = vim.g.vscode == nil,
    version = "v2.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require "config.snippets"
    end,
  },
}
