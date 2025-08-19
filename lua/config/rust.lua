local M = {}

M.opts = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = { enable = true },
        },
        checkOnSave = true,
        diagnostics = { enable = true },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        files = {
          excludeDirs = {
            ".direnv", ".git", ".github", ".gitlab", "bin", "node_modules", "target", "venv", ".venv",
          },
        },
      },
    },
  },
}

M.configure_dap = function(opts)
  local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
  local codelldb = package_path .. "/extension/adapter/codelldb"
  local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
  local uname = io.popen("uname"):read "*l"
  if uname == "Linux" then library_path = package_path .. "/extension/lldb/lib/liblldb.so" end
  opts.dap = { adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path) }
  return opts
end

return M


