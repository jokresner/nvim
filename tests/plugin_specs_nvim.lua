local root = vim.fn.getcwd()

package.path = table.concat({
  root .. "/lua/?.lua",
  root .. "/lua/?/init.lua",
  package.path,
}, ";")

local function fail(msg)
  error(msg, 0)
end

local function find_plugin(specs, repo)
  for _, spec in ipairs(specs) do
    if spec[1] == repo then
      return spec
    end
  end
  fail("missing plugin spec: " .. repo)
end

local function has_string(list, value)
  for _, item in ipairs(list or {}) do
    if item == value then
      return true
    end
  end
  return false
end

local function assert_has_string(list, value, context)
  if not has_string(list, value) then
    fail(context .. " must include " .. value)
  end
end

local lsp_specs = dofile(root .. "/lua/plugins/lsp.lua")
local ui_specs = dofile(root .. "/lua/plugins/ui.lua")
local coding_specs = dofile(root .. "/lua/plugins/coding.lua")
local tool_specs = dofile(root .. "/lua/plugins/tools.lua")

local ensure_spec = find_plugin(lsp_specs, "noirbizarre/ensure.nvim")
local diagflow_spec = find_plugin(ui_specs, "dgagn/diagflow.nvim")
local noice_spec = find_plugin(ui_specs, "folke/noice.nvim")
local neogen_spec = find_plugin(coding_specs, "danymat/neogen")
local neotest_spec = find_plugin(tool_specs, "nvim-neotest/neotest")

if ensure_spec.opts.ensure_installed ~= nil then
  fail("ensure.nvim must not use deprecated/unsupported opts.ensure_installed")
end

if type(ensure_spec.opts.lsp) ~= "table" or type(ensure_spec.opts.lsp.enable) ~= "table" then
  fail("ensure.nvim must configure LSP servers via opts.lsp.enable")
end

for _, server in ipairs(ensure_spec.opts.lsp.enable) do
  if server == "harper_ls" then
    fail("ensure.nvim lsp.enable must not include harper_ls")
  end
end

assert_has_string(ensure_spec.opts.lsp.enable, "lua_ls", "ensure.nvim lsp.enable")
assert_has_string(ensure_spec.opts.lsp.enable, "gopls", "ensure.nvim lsp.enable")
assert_has_string(ensure_spec.opts.lsp.enable, "vtsls", "ensure.nvim lsp.enable")
assert_has_string(ensure_spec.opts.packages, "stylua", "ensure.nvim packages")
assert_has_string(ensure_spec.opts.packages, "golangci-lint", "ensure.nvim packages")
assert_has_string(ensure_spec.opts.packages, "ast-grep", "ensure.nvim packages")

if type(diagflow_spec.opts.scope) ~= "string" or diagflow_spec.opts.scope ~= "line" then
  fail("diagflow.nvim opts.scope must be the flat string value 'line'")
end

if diagflow_spec.opts[1] ~= nil then
  fail("diagflow.nvim opts must be a flat table, not a nested array")
end

if diagflow_spec.opts.padding_right ~= 2 then
  fail("diagflow.nvim opts.padding_right must stay set to 2")
end

assert_has_string(noice_spec.dependencies, "MunifTanjim/nui.nvim", "noice.nvim dependencies")
assert_has_string(noice_spec.dependencies, "rcarriga/nvim-notify", "noice.nvim dependencies")

assert_has_string(neotest_spec.dependencies, "nvim-lua/plenary.nvim", "neotest dependencies")
assert_has_string(neotest_spec.dependencies, "nvim-treesitter/nvim-treesitter", "neotest dependencies")
assert_has_string(neotest_spec.dependencies, "nvim-neotest/nvim-nio", "neotest dependencies")
assert_has_string(neotest_spec.dependencies, "nvim-neotest/neotest-go", "neotest dependencies")
assert_has_string(neotest_spec.dependencies, "olimorris/neotest-phpunit", "neotest dependencies")

local found_neogen_key = false
for _, key in ipairs(neogen_spec.keys or {}) do
  if key[1] == "<leader>cD" then
    found_neogen_key = true
  end
  if key[1] == "<leader>cd" then
    fail("neogen must not use <leader>cd; it conflicts with LSP diagnostics")
  end
end

if not found_neogen_key then
  fail("neogen must expose the <leader>cD keymap")
end

if vim.fn.filereadable(root .. "/lux.toml") == 0 then
  fail("lux.toml must exist")
end

if vim.fn.filereadable(root .. "/lux.lock") == 0 then
  fail("lux.lock must exist")
end

print("plugin spec regression checks passed")
