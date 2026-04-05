local runtime = require("config.pack_runtime")

local M = {}

function M.setup()
  local load_blink = runtime.once(function()
    runtime.load("blink")
    require("blink.cmp").setup(require("config.completion"))
  end)

  local load_copilot = runtime.once(function()
    runtime.load("copilot")
    require("copilot").setup({
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = false,
          next = "<C-j>",
          prev = "<C-p>",
        },
      },
      panel = { enabled = false },
      filetypes = { markdown = true, help = true },
      server_opts_overrides = { settings = { telemetry = { telemetryLevel = "off" } } },
    })
  end)

  local load_supermaven = runtime.once(function()
    runtime.load("supermaven")
    require("supermaven-nvim").setup({
      disable_inline_completion = false,
      disable_keymaps = true,
      ignore_filetypes = { cpp = true },
      log_level = "warn",
    })
  end)

  local load_sidekick = runtime.once(function()
    runtime.load_many({ "mcphub", "sidekick" })
    require("mcphub").setup({
      extensions = {
        sidekick = { make_slash_commands = true },
      },
    })
    require("sidekick").setup({
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    })
  end)

  local load_vectorcode = runtime.once(function()
    runtime.load("vectorcode")
    require("vectorcode").setup({
      async_opts = {
        events = { "BufWritePost", "InsertEnter", "BufReadPost" },
      },
    })
  end)

  local load_neogen = runtime.once(function()
    runtime.load("neogen")
    require("neogen").setup({ snippet_engine = "nvim" })
  end)

  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "CmdlineEnter" }, {
    once = true,
    callback = load_blink,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
      load_copilot()
      load_supermaven()
    end,
  })

  runtime.command("Copilot", load_copilot, { desc = "Open Copilot" })
  runtime.command("Neogen", load_neogen, { desc = "Generate docs" })

  vim.keymap.set({ "n", "i", "x", "t" }, "<C-.>", function()
    load_sidekick()
    require("sidekick.cli").toggle()
  end, { desc = "AI toggle" })
  vim.keymap.set("n", "<leader>aa", function()
    load_sidekick()
    require("sidekick.cli").toggle()
  end, { desc = "AI toggle CLI" })
  vim.keymap.set("n", "<leader>as", function()
    load_sidekick()
    require("sidekick.cli").select()
  end, { desc = "AI select CLI" })
  vim.keymap.set("n", "<leader>ad", function()
    load_sidekick()
    require("sidekick.cli").close()
  end, { desc = "AI detach CLI" })
  vim.keymap.set("n", "<leader>af", function()
    load_sidekick()
    require("sidekick.cli").send({ msg = "{file}" })
  end, { desc = "AI send file" })
  vim.keymap.set({ "n", "x" }, "<leader>at", function()
    load_sidekick()
    require("sidekick.cli").send({ msg = "{this}" })
  end, { desc = "AI send this" })
  vim.keymap.set("x", "<leader>av", function()
    load_sidekick()
    require("sidekick.cli").send({ msg = "{selection}" })
  end, { desc = "AI send selection" })
  vim.keymap.set({ "n", "x" }, "<leader>ap", function()
    load_sidekick()
    require("sidekick.cli").prompt()
  end, { desc = "AI prompt" })
  vim.keymap.set("n", "<leader>ac", function()
    load_sidekick()
    require("sidekick.cli").toggle({ name = "cursor", focus = true })
  end, { desc = "AI toggle cursor" })
  vim.keymap.set("n", "<leader>aV", function()
    load_vectorcode()
  end, { desc = "AI load VectorCode" })
  vim.keymap.set("n", "<leader>cD", function()
    load_neogen()
    require("neogen").generate()
  end, { desc = "Code docs generate" })
end

return M
