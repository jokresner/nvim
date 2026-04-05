local M = {}

local dap = require "dap"

function M.setup()
  require("dap-go").setup()

  M.setupPHP()

  local sign = vim.fn.sign_define
  sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  sign("DapStopped", { texthl = "DapStopped" })
end

function M.setupPHP()
  dap.adapters.php = {
    type = "executable",
    command = "xdebug.sh",
  }
end

return M
