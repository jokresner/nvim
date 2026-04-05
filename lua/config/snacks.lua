local runtime = require("config.pack_runtime")

local M = {}

function M.load()
  runtime.load("snacks")
  if vim.g.__pack_snacks_setup then
    return require("snacks")
  end

  vim.g.__pack_snacks_setup = true

  local snacks = require("snacks")
  snacks.setup({
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
  })

  snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
  snacks.toggle.line_number():map("<leader>ul")
  snacks.toggle.diagnostics():map("<leader>ud")
  snacks.toggle.treesitter():map("<leader>uT")
  snacks.toggle.inlay_hints():map("<leader>ui")
  snacks.toggle.indent():map("<leader>ug")

  return snacks
end

function M.picker(method, opts)
  return M.load().picker[method](opts)
end

function M.terminal(...)
  return M.load().terminal(...)
end

function M.bufdelete(opts)
  return M.load().bufdelete(opts)
end

function M.scratch(...)
  return M.load().scratch(...)
end

function M.scratch_select()
  return M.load().scratch.select()
end

function M.words_jump(count)
  return M.load().words.jump(count)
end

return M
