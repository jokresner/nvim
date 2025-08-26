return {
  {
    "mfussenegger/nvim-dap",
    cond = vim.g.vscode == nil,
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    keys = {
      {
        "<leader>duo",
        function()
          require("dapui").open()
        end,
        desc = "Open DAP UI",
      },
      {
        "<leader>duc",
        function()
          require("dapui").close()
        end,
        desc = "Close DAP UI",
      },
      {
        "<leader>?",
        function()
          require("dapui").eval(nil, { enter = true })
        end,
        desc = "DAP Eval Under Cursor",
      },
      {
        "<space>td",
        function()
          require("dap-go").debug_test()
        end,
        ft = "go",
        desc = "Debug Go Test",
      },
      {
        "<leader>dt",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Inspect REPL",
      },
      {
        "<leader>dk",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate DAP Session",
      },
      {
        "<leader>dso",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dsi",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dsu",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
    },
    config = function()
      require("config.dap").setup()
    end,
  },
}
