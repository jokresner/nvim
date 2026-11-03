-- Run: nvim --headless -u NONE -l tests/run.lua
-- Loads only lua/core and lua/langs (plain Lua), never lazy.nvim or any plugin.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(root)

local mini = vim.fn.stdpath("data") .. "/lazy/mini.nvim"
if not vim.uv.fs_stat(mini) then
    io.stderr:write("mini.nvim not installed at " .. mini .. "\n")
    os.exit(2)
end
vim.opt.rtp:prepend(mini)

local MiniTest = require("mini.test")
MiniTest.setup()
MiniTest.run({
    collect = {
        find_files = function()
            return vim.fn.globpath(root .. "/tests", "test_*.lua", true, true)
        end,
    },
    execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = 1 }) },
})
