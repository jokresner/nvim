return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      local config = require "config.dap"

      ui.setup()
      require("dap-go").setup()

      config.setupGo()

      -- DAP UI keymaps
      vim.keymap.set("n", "<leader>duo", ui.open, { desc = "Open DAP UI" })
      vim.keymap.set("n", "<leader>duc", ui.close, { desc = "Close DAP UI" })

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      -- DAP keymaps
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Inspect REPL" })
      vim.keymap.set("n", "<leader>dk", dap.kill, { desc = "Kill DAP Session" })
      vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dsu", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })

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
    end,
  },
}
