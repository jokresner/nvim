local runtime = require("config.pack_runtime")

vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec or {}
    local name = spec.name or ""
    if name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

runtime.startup_begin()
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    runtime.startup_finish()
  end,
})

local modules = {
  "plugins.core",
  "plugins.ui",
  "plugins.navigation",
  "plugins.editor",
  "plugins.coding",
  "plugins.lsp",
  "plugins.treesitter",
  "plugins.lang",
  "plugins.dap",
  "plugins.tools",
  "plugins.vcs",
  "plugins.notes",
  "plugins.motion",
}

for _, mod in ipairs(modules) do
  require(mod).setup()
end
