local M = {}

M.setup = function()
  -- In the nvim-treesitter 'main' branch, setup() is gone.
  -- Highlighting is managed via native vim.treesitter.start()
  
  -- Handle parser installation once per session (if needed)
  -- We use a global variable to ensure this only runs once.
  if not _G._ts_installed then
    local ts = require("nvim-treesitter")
    local parsers = {
      "lua", "go", "rust", "php", "json", "yaml", "toml",
      "markdown", "markdown_inline", "vim", "vimdoc", "query"
    }
    
    -- Schedule installation to avoid blocking startup
    vim.defer_fn(function()
      for _, p in ipairs(parsers) do
        -- Check if parser is already installed before attempting
        if not vim.treesitter.language.get_lang(p) then
          pcall(ts.install, p)
        end
      end
    end, 1000)
    _G._ts_installed = true
  end

  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
      if lang then
        -- Start native treesitter highlighting
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
