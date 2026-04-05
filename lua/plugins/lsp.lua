local runtime = require("config.pack_runtime")
local snacks = require("config.snacks")

local M = {}

function M.setup()
  local load_ensure = runtime.once(function()
    runtime.load("ensure")
    require("ensure").setup({
      lsp = {
        enable = { "lua_ls", "gopls", "vtsls", "jsonls", "yamlls" },
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags=unittest" },
            },
          },
        },
      },
      packages = {
        "stylua",
        "delve",
        "codelldb",
        "golangci-lint",
        "luacheck",
        "ast-grep",
      },
    })
  end)

  local load_mason = runtime.once(function()
    runtime.load("mason")
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end)

  local load_lspconfig = runtime.once(function()
    load_mason()
    runtime.load_many({ "mason-lspconfig", "lspconfig" })
    require("config.lsp").setup()
  end)

  local load_conform = runtime.once(function()
    runtime.load("conform")
    require("conform").setup(require("config.format").opts)
  end)

  local load_lint = runtime.once(function()
    runtime.load("lint")
    require("config.lint").setup()
  end)

  local load_trouble = runtime.once(function()
    runtime.load("trouble")
    require("trouble").setup({})
  end)

  runtime.defer(load_ensure)
  runtime.command("Mason", load_mason, { desc = "Open Mason" })
  runtime.command("Trouble", load_trouble, { desc = "Open Trouble" })

  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = load_lspconfig,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = load_conform,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    callback = load_lint,
  })

  vim.api.nvim_create_user_command("Format", function()
    load_conform()
    require("conform").format({ async = true, lsp_fallback = true })
  end, { desc = "Format current buffer" })

  vim.keymap.set("n", "<leader>cf", "<cmd>Format<cr>", { desc = "Code format" })
  vim.keymap.set("n", "<leader>xx", function()
    snacks.picker("diagnostics")
  end, { desc = "Diagnostics list" })
  vim.keymap.set("n", "<leader>xX", function()
    snacks.picker("diagnostics_buffer")
  end, { desc = "Buffer diagnostics" })
  vim.keymap.set("n", "<leader>xq", function()
    snacks.picker("qflist")
  end, { desc = "Quickfix list" })
  vim.keymap.set("n", "<leader>xl", function()
    snacks.picker("loclist")
  end, { desc = "Location list" })
end

return M
