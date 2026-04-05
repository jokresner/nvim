local root = vim.fn.getcwd()

local function fail(msg)
  error(msg, 0)
end

local function read_file(path)
  local lines = vim.fn.readfile(path)
  return table.concat(lines, "\n")
end

local keymaps_src = read_file(root .. "/lua/config/keymaps.lua")
local commands_src = read_file(root .. "/lua/config/commands.lua")

if not keymaps_src:find([[map("n", "<leader>y", '"+yy', { desc = "Yank line to clipboard" })]], 1, true) then
  fail("keymaps must map normal-mode <leader>y to line yank in the system clipboard")
end

if not keymaps_src:find([[map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })]], 1, true) then
  fail("keymaps must map visual-mode <leader>y to clipboard yank")
end

if keymaps_src:find("<leader>Y", 1, true) then
  fail("keymaps must not keep the old <leader>Y clipboard mapping")
end

if commands_src:find("TSContextEnable", 1, true) or commands_src:find("TSContextDisable", 1, true) then
  fail("context mode commands must not call removed TSContextEnable/TSContextDisable commands")
end

if not commands_src:find("ts_context.enable()", 1, true) then
  fail("context mode must enable treesitter-context through the Lua API")
end

if not commands_src:find("ts_context.disable()", 1, true) then
  fail("context mode must disable treesitter-context through the Lua API")
end

print("config regression checks passed")
