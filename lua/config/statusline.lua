local M = {}

M.setup = function()
  local ok, statusline = pcall(require, "mini.statusline")
  if not ok then return end
  statusline.setup({ use_icons = vim.g.have_nerd_font })
end

return M


