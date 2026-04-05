local runtime = require("config.pack_runtime")

local M = {}

function M.setup()
  local load_lazydev = runtime.once(function()
    runtime.load("lazydev")
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })
  end)

  local load_icons = runtime.once(function()
    runtime.load("mini-icons")
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()
  end)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    once = true,
    callback = load_lazydev,
  })

  runtime.defer(load_icons)
end

return M
