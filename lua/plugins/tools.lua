return {
  {
    "nvim-mini/mini.sessions",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>qs", function() require("mini.sessions").read(nil, { force = true }) end, desc = "Session restore" },
      { "<leader>qS", function() require("mini.sessions").select() end, desc = "Session select" },
      { "<leader>ql", function() require("mini.sessions").read(vim.v.this_session or nil, { force = true }) end, desc = "Session last" },
      { "<leader>qd", function() require("mini.sessions").write("", { force = true }) end, desc = "Session disable save" },
    },
  },
  { "nvim-mini/mini.operators", event = "VeryLazy", opts = {} },
  { "ten3roberts/qf.nvim", ft = "qf", opts = {} },
  { "beauwilliams/focus.nvim", event = "VeryLazy", opts = {} },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      { "<leader>Rs", desc = "REST send request" },
      { "<leader>Ra", desc = "REST send all" },
      { "<leader>Rb", desc = "REST open scratch" },
    },
    opts = {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
  {
    "kndndrj/nvim-dbee",
    cmd = "DBee",
    build = function()
      require("dbee").install()
    end,
    opts = function()
      local ok, sources = pcall(require, "dbee.sources")
      if not ok then
        return {}
      end
      return {
        sources = {
          sources.FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
        },
      }
    end,
    init = function()
      vim.api.nvim_create_user_command("DBee", function()
        require("dbee").open()
      end, { desc = "Open DBee" })
    end,
  },
  {
    "stevearc/overseer.nvim",
    version = "v1.6.0",
    cmd = { "OverseerToggle", "OverseerRun", "OverseerBuild", "OverseerTaskAction", "OverseerInfo", "OverseerClearCache" },
    opts = {
      dap = false,
      task_list = {
        bindings = {
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
        },
      },
      form = { win_opts = { winblend = 0 } },
      confirm = { win_opts = { winblend = 0 } },
      task_win = { win_opts = { winblend = 0 } },
    },
    keys = {
      { "<leader>xw", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>xo", "<cmd>OverseerRun<cr>", desc = "Task run" },
      { "<leader>xi", "<cmd>OverseerInfo<cr>", desc = "Task info" },
      { "<leader>xb", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
      { "<leader>xt", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      { "<leader>xc", "<cmd>OverseerClearCache<cr>", desc = "Task clear cache" },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
      "olimorris/neotest-phpunit",
    },
    opts = {
      discovery = { enabled = false, concurrent = 1 },
      running = { concurrent = true },
      summary = { animated = true },
    },
    config = function(_, opts)
      local ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(d)
            return d.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, ns)
      opts.adapters = { require("neotest-go"), require("neotest-phpunit") }
      require("neotest").setup(opts)
    end,
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test run nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test run file" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test run all" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test run last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test watch" },
    },
  },
  {
    "saxon1964/neovim-tips",
    cmd = "NeovimTips",
    opts = {
      daily_tip = 0,
      bookmark_symbol = "* ",
    },
    keys = {
      { "<leader>kt", "<cmd>NeovimTips<cr>", desc = "Knowledge tips" },
    },
  },
  {
    "swaits/zellij-nav.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>zh", "<cmd>ZellijNavigateLeftTab<cr>", desc = "Zellij left" },
      { "<leader>zj", "<cmd>ZellijNavigateDown<cr>", desc = "Zellij down" },
      { "<leader>zk", "<cmd>ZellijNavigateUp<cr>", desc = "Zellij up" },
      { "<leader>zl", "<cmd>ZellijNavigateRightTab<cr>", desc = "Zellij right" },
    },
  },
  { "atiladefreitas/dooing", cmd = "Dooing", opts = {} },
  { "alex-popov-tech/store.nvim", cmd = "Store", dependencies = { "OXY2DEV/markview.nvim" } },
}
