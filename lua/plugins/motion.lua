local runtime = require("config.pack_runtime")

local M = {}

function M.setup()
  local load_spider = runtime.once(function()
    runtime.load("spider")
  end)

  local function map(lhs, motion, desc)
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
      load_spider()
      require("spider").motion(motion)
    end, { desc = desc })
  end

  map("w", "w", "Next subword start")
  map("b", "b", "Prev subword start")
  map("e", "e", "Next subword end")
  map("ge", "ge", "Prev subword end")
end

return M
