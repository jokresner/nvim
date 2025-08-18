local M = {}

M.setup = function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then return end
  gitsigns.setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
  })
end

return M


