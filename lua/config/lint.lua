local M = {}

M.opts = {
  events = { "BufWritePost", "BufReadPost", "InsertLeave" },
  linters_by_ft = {
    fish = { "fish" },
    go = { "golangci-lint" },
    rust = { "bacon" },
    lua = { "luacheck" },
  },
  linters = {},
}

function M.setup()
  local lint = require "lint"
  local opts = M.opts

  lint.linters_by_ft = opts.linters_by_ft

  local function debounce(ms, fn)
    local timer = vim.uv.new_timer()
    return function(...)
      local argv = { ... }
      timer:start(ms, 0, function()
        timer:stop()
        vim.schedule_wrap(fn)(unpack(argv))
      end)
    end
  end

  local function run_lint()
    -- Use public try_lint API
    lint.try_lint()
  end

  vim.api.nvim_create_autocmd(opts.events, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = debounce(100, run_lint),
  })
end

return M
