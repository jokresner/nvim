return {
  {
    "nvim-lualine/lualine.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    opts = function()
      return require("config.statusline").lualine
    end,
  },
  {
    "serhez/bento.nvim",
    event = "VeryLazy",
    opts = {
      main_keymap = "ö",
      max_open_buffers = 10,
      actions = {
        vsplit = { key = "v" },
        split = { key = "h" },
        lock = { key = "l" },
        delete = { key = "d" },
        prev_page = {
          key = "p",
          action = function()
            require("bento.ui").prev_page()
          end,
        },
        next_page = {
          key = "n",
          action = function()
            require("bento.ui").next_page()
          end,
        },
      },
      ui = {
        mode = "floating",
        floating = {
          position = "middle-left",
        },
      },
    },
  },
}
