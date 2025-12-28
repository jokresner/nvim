local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      -- Enable highlighting if a parser is available
      local ok, _ = pcall(vim.treesitter.start)
      -- Enable indentation
      if ok then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
