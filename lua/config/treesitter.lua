local M = {}

M.setup = function()
  -- In the nvim-treesitter 'main' branch, setup() is gone.
  -- Highlighting is managed via native vim.treesitter.start()

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user-treesitter-native", { clear = true }),
    callback = function(ev)
      local ft = vim.bo[ev.buf].filetype
      local lang = vim.treesitter.language.get_lang(ft)
      if not lang then
        return
      end

      -- Start native treesitter highlighting for this buffer.
      pcall(vim.treesitter.start, ev.buf, lang)

      -- Only enable TS indent when nothing else configured it.
      if vim.bo[ev.buf].indentexpr == "" then
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
