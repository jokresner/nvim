local runtime = require("config.pack_runtime")

local M = {}

function M.setup()
  local load_treesitter = runtime.once(function()
    runtime.load_many({ "treesitter", "treesitter-textobjects", "treesitter-context" })
    require("config.treesitter").setup()
  end)

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    once = true,
    callback = load_treesitter,
  })

  runtime.command("TSUpdate", load_treesitter, { desc = "Update treesitter parsers" })
  runtime.command("TSInstall", load_treesitter, { desc = "Install treesitter parsers" })
end

return M
