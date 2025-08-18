-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
  if not ok then return end

  ts_configs.setup({
    ensure_installed = { "lua", "go", "rust", "vim", "vimdoc", "markdown", "markdown_inline", "bash", "json", "toml", "yaml" },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
  })

  -- Enable treesitter highlighting for buffers with a parser
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
