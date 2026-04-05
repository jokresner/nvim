local root = vim.fn.getcwd()

package.path = table.concat({
  root .. "/lua/?.lua",
  root .. "/lua/?/init.lua",
  package.path,
}, ";")

local function fail(msg)
  error(msg, 0)
end

require("config.pack")

local registry = require("config.pack_registry")
local runtime = require("config.pack_runtime")

local function expect_spec(name)
  local spec = registry[name]
  if not spec then
    fail("missing pack registry entry: " .. name)
  end
  return spec
end

local ensure_spec = expect_spec("ensure")
local diagflow_spec = expect_spec("diagflow")
local noice_spec = expect_spec("noice")
local neogen_spec = expect_spec("neogen")
local neotest_spec = expect_spec("neotest")
local schemastore_spec = expect_spec("schemastore")
local treesitter_context_spec = expect_spec("treesitter-context")

if ensure_spec.src ~= "https://github.com/noirbizarre/ensure.nvim" then
  fail("ensure registry entry must point to noirbizarre/ensure.nvim")
end

if diagflow_spec.src ~= "https://github.com/dgagn/diagflow.nvim" then
  fail("diagflow registry entry must point to dgagn/diagflow.nvim")
end

if noice_spec.src ~= "https://github.com/folke/noice.nvim" then
  fail("noice registry entry must point to folke/noice.nvim")
end

if neogen_spec.src ~= "https://github.com/danymat/neogen" then
  fail("neogen registry entry must point to danymat/neogen")
end

if neotest_spec.src ~= "https://github.com/nvim-neotest/neotest" then
  fail("neotest registry entry must point to nvim-neotest/neotest")
end

if schemastore_spec.name ~= "SchemaStore.nvim" then
  fail("schemastore registry entry must keep the SchemaStore.nvim package name")
end

if treesitter_context_spec.src ~= "https://github.com/nvim-treesitter/nvim-treesitter-context" then
  fail("treesitter-context registry entry must be explicit")
end

for _, dep_name in ipairs({ "plenary", "nui", "notify", "promise-async", "volt", "mason-lspconfig", "mason-nvim-dap", "treesitter-textobjects", "nio", "neotest-go", "neotest-phpunit", "mcphub", "diffview" }) do
  expect_spec(dep_name)
end

if vim.fn.exists(":Format") ~= 2 then
  fail("Format command must be defined during startup")
end

if vim.fn.exists(":DBee") ~= 2 then
  fail("DBee command must be defined during startup")
end

if vim.fn.exists(":Obsidian") ~= 2 then
  fail("Obsidian command must be defined during startup")
end

if vim.fn.exists(":Mason") ~= 2 then
  fail("Mason command must be defined during startup")
end

local loaded_before = runtime.stats().loaded
runtime.load("snacks")
local loaded_after_first = runtime.stats().loaded
runtime.load("snacks")
local loaded_after_second = runtime.stats().loaded

if loaded_after_first <= loaded_before then
  fail("runtime.load must increase the loaded plugin count on first load")
end

if loaded_after_second ~= loaded_after_first then
  fail("runtime.load must be idempotent")
end

print("pack registry regression checks passed")
