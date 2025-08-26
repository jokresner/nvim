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
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return opts
  end

  if not registry.has_package("codelldb") then
    registry.refresh(function()
      M.configure_dap(opts)
    end)
    return opts
  end

  local pkg = registry.get_package("codelldb")
  if pkg and pkg.is_installed and not pkg:is_installed() then
    return opts
  end

  local package_path = pkg and pkg.get_install_path and pkg:get_install_path()
  if not package_path or package_path == "" then
    return opts
  end

  local codelldb = package_path .. "/extension/adapter/codelldb"
  local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
  local uname = io.popen("uname"):read "*l"
  if uname == "Linux" then library_path = package_path .. "/extension/lldb/lib/liblldb.so" end
  opts.dap = { adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path) }
  return opts
end

return M


