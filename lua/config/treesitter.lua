-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "lua", "vim", "vimdoc", "query",
      "go", "rust", "php",
      "json", "yaml", "toml",
      "markdown", "markdown_inline",
    },
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "php" },
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Outer function" },
          ["if"] = { query = "@function.inner", desc = "Inner function" },
          ["ac"] = { query = "@class.outer", desc = "Outer class" },
          ["ic"] = { query = "@class.inner", desc = "Inner class" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]c"] = "@class.outer",
          ["gnf"] = "@function.outer",
          ["gnc"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["gnF"] = "@function.outer",
          ["gnC"] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["gpf"] = "@function.outer",
          ["gpc"] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["gpF"] = "@function.outer",
          ["gpC"] = "@class.outer",
        },
      },
    },
  }
end

return M
