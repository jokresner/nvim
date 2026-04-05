local runtime = require("config.pack_runtime")
local snacks = require("config.snacks")

local M = {}

function M.setup()
  local load_comment = runtime.once(function()
    runtime.load("mini-comment")
    require("mini.comment").setup({})
  end)

  local load_surround = runtime.once(function()
    runtime.load("mini-surround")
    require("mini.surround").setup({
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    })
  end)

  local load_ai = runtime.once(function()
    runtime.load("mini-ai")
    require("mini.ai").setup({})
  end)

  local load_todo_comments = runtime.once(function()
    snacks.load()
    runtime.load("todo-comments")
    require("todo-comments").setup({})
  end)

  local load_spectre = runtime.once(function()
    runtime.load("spectre")
  end)

  local load_refactoring = runtime.once(function()
    runtime.load_many({ "treesitter", "refactoring" })
    require("refactoring").setup({})
  end)

  local load_flash = runtime.once(function()
    runtime.load("flash")
    require("flash").setup({})
  end)

  runtime.defer(load_comment)
  runtime.defer(load_surround)
  runtime.defer(load_ai)

  vim.keymap.set("n", "<leader>ct", function()
    load_todo_comments()
    snacks.picker("todo_comments")
  end, { desc = "Code todos" })

  vim.keymap.set("n", "<leader>cT", function()
    load_todo_comments()
    snacks.picker("todo_comments", { keywords = { "TODO", "FIX", "FIXME" } })
  end, { desc = "Code todo+fix" })

  runtime.command("Spectre", load_spectre, { desc = "Load Spectre" })
  vim.keymap.set("n", "<leader>sr", function()
    load_spectre()
    require("spectre").open()
  end, { desc = "Search replace files" })

  vim.keymap.set("v", "<leader>rr", function()
    load_refactoring()
    require("refactoring").select_refactor()
  end, { desc = "Refactor selection" })

  vim.keymap.set({ "n", "x", "o" }, "s", function()
    load_flash()
    require("flash").jump()
  end, { desc = "Flash jump" })
  vim.keymap.set({ "n", "x", "o" }, "S", function()
    load_flash()
    require("flash").treesitter()
  end, { desc = "Flash treesitter" })
  vim.keymap.set("o", "r", function()
    load_flash()
    require("flash").remote()
  end, { desc = "Flash remote" })
  vim.keymap.set({ "o", "x" }, "R", function()
    load_flash()
    require("flash").treesitter_search()
  end, { desc = "Flash treesitter search" })
  vim.keymap.set("c", "<C-s>", function()
    load_flash()
    require("flash").toggle()
  end, { desc = "Flash toggle search" })
end

return M
