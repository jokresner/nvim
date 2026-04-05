local runtime = require("config.pack_runtime")

local M = {}

function M.setup()
  local load_rust = runtime.once(function()
    local opts = require("config.rust").opts
    opts = require("config.rust").configure_dap(opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    runtime.load("rustaceanvim")
    if vim.fn.executable("rust-analyzer") == 0 then
      vim.health.error(
        "rust-analyzer not found in PATH. Install from https://rust-analyzer.github.io/",
        { title = "rustaceanvim" }
      )
    end
  end)

  local load_ts_error = runtime.once(function()
    runtime.load("ts-error-translator")
  end)

  local load_gopher = runtime.once(function()
    runtime.load("gopher")
    require("gopher").setup({})
  end)

  local load_jira = runtime.once(function()
    runtime.load("jira")
  end)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    once = true,
    callback = function()
      load_rust()
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact" },
    once = true,
    callback = load_ts_error,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    once = true,
    callback = load_gopher,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
      vim.keymap.set("n", "<leader>ca", function()
        load_rust()
        vim.cmd.RustLsp("codeAction")
      end, { buffer = ev.buf, desc = "Code Action (Rust)" })
      vim.keymap.set("n", "<leader>dd", function()
        load_rust()
        vim.cmd.RustLsp("debuggables")
      end, { buffer = ev.buf, desc = "Rust debuggables" })
    end,
  })

  runtime.command("Jira", load_jira, { desc = "Open Jira" })
  vim.keymap.set("n", "<leader>jb", "<cmd>Jira<cr>", { desc = "Jira board" })
end

return M
