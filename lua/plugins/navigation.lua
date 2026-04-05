return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    opts = {
      animate = { enabled = false },
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      image = { enabled = true },
      input = { enabled = false },
      notifier = { enabled = false },
      notify = { enabled = false },
      picker = { enabled = true, ui_select = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scratch = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
      zen = { enabled = false },
    },
    keys = {
      { "<leader><space>", "<Plug>(NeuralOpen)", desc = "Find smart files" },
      { "<leader>,", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command history" },
      { "<leader>bb", function() require("snacks").picker.buffers() end, desc = "Buffer list" },
      { "<leader>bn", "<cmd>bnext<cr>", desc = "Buffer next" },
      { "<leader>bp", "<cmd>bprevious<cr>", desc = "Buffer previous" },
      { "<leader>fc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config" },
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find files" },
      { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Find grep" },
      { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Find recent" },
      { "<leader>fp", function() require("snacks").picker.projects() end, desc = "Find projects" },
      { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Find buffers" },
      { "<leader>fh", function() require("snacks").picker.help() end, desc = "Find help" },
      { "<leader>sa", function() require("snacks").picker.autocmds() end, desc = "Search autocmds" },
      { "<leader>sb", function() require("snacks").picker.lines() end, desc = "Search buffer lines" },
      { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Search open buffers" },
      { "<leader>sc", function() require("snacks").picker.command_history() end, desc = "Search command history" },
      { "<leader>sC", function() require("snacks").picker.commands() end, desc = "Search commands" },
      { "<leader>sk", function() require("snacks").picker.keymaps() end, desc = "Search keymaps" },
      { "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "Search diagnostics" },
      { "<leader>sD", function() require("snacks").picker.diagnostics_buffer() end, desc = "Search buffer diagnostics" },
      { "<leader>sg", function() require("snacks").picker.grep() end, desc = "Search grep" },
      { "<leader>sh", function() require("snacks").picker.help() end, desc = "Search help" },
      { "<leader>sj", function() require("snacks").picker.jumps() end, desc = "Search jumps" },
      { "<leader>sl", function() require("snacks").picker.loclist() end, desc = "Search location list" },
      { "<leader>sm", function() require("snacks").picker.marks() end, desc = "Search marks" },
      { "<leader>sq", function() require("snacks").picker.qflist() end, desc = "Search quickfix" },
      { "<leader>sR", function() require("snacks").picker.resume() end, desc = "Search resume" },
      { "<leader>su", function() require("snacks").picker.undo() end, desc = "Search undo history" },
      { "<leader>sw", function() require("snacks").picker.grep_word() end, mode = { "n", "x" }, desc = "Search word" },
      { "<leader>ss", function() require("snacks").picker.lsp_symbols() end, desc = "Search symbols" },
      { "<leader>sS", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "Search workspace symbols" },
      { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git branches" },
      { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "Git status" },
      { "<leader>gl", function() require("snacks").picker.git_log() end, desc = "Git log" },
      { "<leader>gL", function() require("snacks").picker.git_log_line() end, desc = "Git log line" },
      { "<leader>gf", function() require("snacks").picker.git_log_file() end, desc = "Git log file" },
      { "<leader>gS", function() require("snacks").picker.git_stash() end, desc = "Git stash" },
      { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Buffer delete" },
      { "<leader>bD", function() require("snacks").bufdelete({ force = true }) end, desc = "Buffer delete force" },
      { "<C-/>", function() require("snacks").terminal() end, desc = "Toggle terminal" },
      { "<C-_>", function() require("snacks").terminal() end, desc = "Toggle terminal" },
      { "<leader>.", function() require("snacks").scratch() end, desc = "Scratch toggle" },
      { "<leader>S", function() require("snacks").scratch.select() end, desc = "Scratch select" },
      { "<leader>cn", function() require("snacks").words.jump(vim.v.count1) end, mode = { "n", "t" }, desc = "Code next reference" },
      { "<leader>cp", function() require("snacks").words.jump(-vim.v.count1) end, mode = { "n", "t" }, desc = "Code prev reference" },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
      snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
      snacks.toggle.line_number():map("<leader>ul")
      snacks.toggle.diagnostics():map("<leader>ud")
      snacks.toggle.treesitter():map("<leader>uT")
      snacks.toggle.inlay_hints():map("<leader>ui")
      snacks.toggle.indent():map("<leader>ug")
      vim.keymap.set("n", "<leader>uC", function() snacks.picker.colorschemes() end, { desc = "Colorschemes" })
    end,
  },
  {
    "dtormoen/neural-open.nvim",
    lazy = false,
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { "<leader>-", "<cmd>Oil<cr>", desc = "Open Oil at the current file" },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "-", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
    },
    opts = {
      open_for_directories = true,
      open_multiple_tabs = true,
      keymaps = { show_help = "<f1>" },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "nvim-mini/mini.visits",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.visits").setup()
    end,
    keys = {
      {
        "<leader>vy",
        function()
          require("mini.visits").add_label "core"
        end,
        desc = "Visits: add 'core' label",
      },
      {
        "<leader>vd",
        function()
          require("mini.visits").delete_label "core"
        end,
      },
      {
        "<leader>vY",
        function()
          require("mini.visits").select_path(nil, { filter = "core" })
        end,
        desc = "Visits: select 'core' (cwd)",
      },
      {
        "<leader>v1",
        function()
          require("mini.visits").iterate_paths("first", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits first",
      },
      {
        "<leader>v2",
        function()
          require("mini.visits").iterate_paths("backward", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits backward",
      },
      {
        "<leader>v3",
        function()
          require("mini.visits").iterate_paths("forward", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits forward",
      },
      {
        "<leader>v4",
        function()
          require("mini.visits").iterate_paths("last", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits last",
      },
    },
  },
}
