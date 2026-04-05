return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug breakpoint toggle" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug repl" },
      { "<leader>du", function() require("dap-view").toggle() end, desc = "Debug UI toggle" },
    },
    dependencies = {
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      { "igorlfs/nvim-dap-view", opts = { auto_toggle = true } },
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("config.dap").setup()
    end,
  },
}
