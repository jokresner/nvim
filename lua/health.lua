local M = {}

M.check = function()
  vim.health.start "Johannes Nvim Config"

  -- Check Neovim version
  local nvim_version = vim.version()
  if nvim_version.major >= 0 and nvim_version.minor >= 10 then
    vim.health.ok(string.format("Neovim %d.%d.%d", nvim_version.major, nvim_version.minor, nvim_version.patch))
  else
    vim.health.warn "Consider upgrading to Neovim 0.10+"
  end

  -- Check external dependencies
  local deps = {
    "rg",
    "fd",
    "lazygit",
    "yazi",
    "node",
    "go",
    "rust",
    "pnpm",
    "zellij",
    "glow",
    "jq",
  }

  for _, dep in ipairs(deps) do
    if vim.fn.executable(dep) == 1 then
      vim.health.ok(dep .. " is installed")
    else
      vim.health.warn(dep .. " is not installed")
    end
  end

  -- Check LSP servers
  vim.health.info "Run :Mason to check LSP server installations"
end

return M
