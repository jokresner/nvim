-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  require("nvim-treesitter").install {
    "lua",
    "go",
    "rust",
    "php",
    "json",
    "yaml",
    "toml",
    "markdown",
    "markdown_inline",
  }
end

return M
