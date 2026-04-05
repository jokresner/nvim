local M = {}

M.ensure_installed = {
  "bash",
  "comment",
  "css",
  "diff",
  "go",
  "gomod",
  "gosum",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "php",
  "query",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

function M.setup()
  if vim.fn.executable("tree-sitter") == 1 then
    require("nvim-treesitter").install(M.ensure_installed)
  elseif not vim.g._treesitter_cli_warned then
    vim.g._treesitter_cli_warned = true
    vim.schedule(function()
      vim.notify(
        "tree-sitter CLI not found; skipping parser auto-install. Install `tree-sitter` to enable automatic parser installs.",
        vim.log.levels.WARN
      )
    end)
  end

  local group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
      local ft = vim.bo[event.buf].filetype
      local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
      if not ok or not lang then
        return
      end
      pcall(vim.treesitter.start, event.buf, lang)
    end,
  })
end

return M
