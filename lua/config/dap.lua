local M = {}

local dap = require "dap"

function M.setup()
  local ui = require "dapui"
  ui.setup()
  pcall(function()
    require("dapview").setup()
  end)
  require("dap-go").setup()

  M.setupGo()
  M.setupPHP()

  require("dap.ext.vscode").load_launchjs(nil, { include = { "php", "go" } })

  local sign = vim.fn.sign_define
  sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  sign("DapStopped", { texthl = "DapStopped" })

  dap.listeners.before.attach.dapui_config = function()
    ui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    ui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
  end
end

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
