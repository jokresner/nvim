local M = {}

M.setup = function()
  local ok, wk = pcall(require, "which-key")
  if not ok then return end
  wk.setup({
    icons = { mappings = vim.g.have_nerd_font },
  })
  wk.add({
    { "<leader>a", group = "[A]I Chat" },
    { "<leader>b", group = "[B]uffer" },
    { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
    { "<leader>d", group = "[D]ebug" },
    { "<leader>f", group = "[F]ind" },
    { "<leader>g", group = "[G]it" },
    { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
    { "<leader>m", group = "Tests" },
    { "<leader>q", group = "Session Management" },
    { "<leader>r", group = "[R]un" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>u", group = "+Toggle" },
    { "<leader>w", group = "[W]orkspace" },
    { "<leader>t", group = "[T]rouble" },
    { "<leader>x", group = "E[x]ecute Task" },
  })
end

return M


