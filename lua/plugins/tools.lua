local runtime = require("config.pack_runtime")

local M = {}

function M.setup()
  local load_sessions = runtime.once(function()
    runtime.load("mini-sessions")
    require("mini.sessions").setup({})
  end)

  local load_operators = runtime.once(function()
    runtime.load("mini-operators")
    require("mini.operators").setup({})
  end)

  local load_qf = runtime.once(function()
    runtime.load("qf")
    require("qf").setup({})
  end)

  local load_focus = runtime.once(function()
    runtime.load("focus")
    require("focus").setup({})
  end)

  local load_kulala = runtime.once(function()
    runtime.load("kulala")
    require("kulala").setup({
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    })
  end)

  local load_dbee = runtime.once(function()
    runtime.load("dbee")
    local ok, sources = pcall(require, "dbee.sources")
    local opts = {}
    if ok then
      opts.sources = {
        sources.FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
      }
    end
    require("dbee").setup(opts)
  end)

  local load_overseer = runtime.once(function()
    runtime.load("overseer")
    require("overseer").setup({
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
    })
  end)

  local load_neotest = runtime.once(function()
    runtime.load_many({ "plenary", "treesitter", "nio", "neotest-go", "neotest-phpunit", "neotest" })
    local opts = {
      discovery = { enabled = false, concurrent = 1 },
      running = { concurrent = true },
      summary = { animated = true },
    }
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
  end)

  local load_neovim_tips = runtime.once(function()
    runtime.load("neovim-tips")
    require("neovim-tips").setup({ daily_tip = 0, bookmark_symbol = "* " })
  end)

  local load_zellij_nav = runtime.once(function()
    runtime.load("zellij-nav")
  end)

  local load_dooing = runtime.once(function()
    runtime.load("dooing")
    require("dooing").setup({})
  end)

  local load_store = runtime.once(function()
    runtime.load_many({ "markview", "store" })
  end)

  runtime.defer(load_sessions)
  runtime.defer(load_operators)
  runtime.defer(load_focus)
  runtime.defer(load_zellij_nav)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    once = true,
    callback = load_qf,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "http", "rest" },
    once = true,
    callback = load_kulala,
  })

  vim.keymap.set("n", "<leader>qs", function()
    load_sessions()
    require("mini.sessions").read(nil, { force = true })
  end, { desc = "Session restore" })
  vim.keymap.set("n", "<leader>qS", function()
    load_sessions()
    require("mini.sessions").select()
  end, { desc = "Session select" })
  vim.keymap.set("n", "<leader>ql", function()
    load_sessions()
    require("mini.sessions").read(vim.v.this_session or nil, { force = true })
  end, { desc = "Session last" })
  vim.keymap.set("n", "<leader>qd", function()
    load_sessions()
    require("mini.sessions").write("", { force = true })
  end, { desc = "Session disable save" })

  runtime.command("DBee", load_dbee, {
    desc = "Open DBee",
    invoke = function()
      require("dbee").open()
    end,
  })

  for _, cmd in ipairs({ "OverseerToggle", "OverseerRun", "OverseerBuild", "OverseerTaskAction", "OverseerInfo", "OverseerClearCache" }) do
    runtime.command(cmd, load_overseer, { desc = "Load Overseer" })
  end

  vim.keymap.set("n", "<leader>xw", "<cmd>OverseerToggle<cr>", { desc = "Task list" })
  vim.keymap.set("n", "<leader>xo", "<cmd>OverseerRun<cr>", { desc = "Task run" })
  vim.keymap.set("n", "<leader>xi", "<cmd>OverseerInfo<cr>", { desc = "Task info" })
  vim.keymap.set("n", "<leader>xb", "<cmd>OverseerBuild<cr>", { desc = "Task builder" })
  vim.keymap.set("n", "<leader>xt", "<cmd>OverseerTaskAction<cr>", { desc = "Task action" })
  vim.keymap.set("n", "<leader>xc", "<cmd>OverseerClearCache<cr>", { desc = "Task clear cache" })

  vim.keymap.set("n", "<leader>tt", function()
    load_neotest()
    require("neotest").run.run()
  end, { desc = "Test run nearest" })
  vim.keymap.set("n", "<leader>tf", function()
    load_neotest()
    require("neotest").run.run(vim.fn.expand("%"))
  end, { desc = "Test run file" })
  vim.keymap.set("n", "<leader>ta", function()
    load_neotest()
    require("neotest").run.run(vim.uv.cwd())
  end, { desc = "Test run all" })
  vim.keymap.set("n", "<leader>tl", function()
    load_neotest()
    require("neotest").run.run_last()
  end, { desc = "Test run last" })
  vim.keymap.set("n", "<leader>ts", function()
    load_neotest()
    require("neotest").summary.toggle()
  end, { desc = "Test summary" })
  vim.keymap.set("n", "<leader>to", function()
    load_neotest()
    require("neotest").output.open({ enter = true, auto_close = true })
  end, { desc = "Test output" })
  vim.keymap.set("n", "<leader>tO", function()
    load_neotest()
    require("neotest").output_panel.toggle()
  end, { desc = "Test output panel" })
  vim.keymap.set("n", "<leader>tw", function()
    load_neotest()
    require("neotest").watch.toggle(vim.fn.expand("%"))
  end, { desc = "Test watch" })

  runtime.command("NeovimTips", load_neovim_tips, { desc = "Show Neovim tips" })
  vim.keymap.set("n", "<leader>kt", "<cmd>NeovimTips<cr>", { desc = "Knowledge tips" })

  vim.keymap.set("n", "<leader>zh", function()
    load_zellij_nav()
    vim.cmd.ZellijNavigateLeftTab()
  end, { desc = "Zellij left" })
  vim.keymap.set("n", "<leader>zj", function()
    load_zellij_nav()
    vim.cmd.ZellijNavigateDown()
  end, { desc = "Zellij down" })
  vim.keymap.set("n", "<leader>zk", function()
    load_zellij_nav()
    vim.cmd.ZellijNavigateUp()
  end, { desc = "Zellij up" })
  vim.keymap.set("n", "<leader>zl", function()
    load_zellij_nav()
    vim.cmd.ZellijNavigateRightTab()
  end, { desc = "Zellij right" })

  runtime.command("Dooing", load_dooing, { desc = "Open dooing" })
  runtime.command("Store", load_store, { desc = "Open store" })
end

return M
