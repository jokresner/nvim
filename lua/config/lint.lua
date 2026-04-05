local M = {}

M.events = { "BufWritePost", "BufReadPost", "InsertLeave" }

M.linters_by_ft = {
  fish = { "fish" },
  go = { "golangcilint" },
  rust = { "bacon" },
  lua = { "luacheck" },
}

function M.setup()
  local lint = require("lint")
  lint.linters_by_ft = M.linters_by_ft

  local timer = vim.uv.new_timer()
  local group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      pcall(timer.stop, timer)
      pcall(timer.close, timer)
    end,
  })

  vim.api.nvim_create_autocmd(M.events, {
    group = group,
    callback = function()
      timer:start(120, 0, vim.schedule_wrap(function()
        lint.try_lint()
      end))
    end,
  })
end

return M
