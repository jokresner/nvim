local M = {}

local dap = require "dap"

function M.setupGo()
  dap.adapters.delve = function(callback, config)
    if config.mode == "remote" and config.request == "attach" then
      callback { type = "server", host = config.host or "127.0.0.1", port = config.port or "38697" }
    else
      callback {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output-dap" },
          detach = vim.fn.has "win32" == 0,
        },
      }
    end
  end

  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }
end

function M.setupPHP()
  dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath "data" .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
  }

  dap.configurations.php = {
    {
      type = "php",
      request = "launch",
      name = "Listen for Xdebug",
      port = 9001,
    },
    {
      type = "php",
      request = "launch",
      name = "Launch currently open script",
      port = 9001,
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "php",
      runtimeArgs = { "-dxdebug.start_with_request=yes" },
    },
  }
end

return M
