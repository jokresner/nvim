return {
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    spec = {
      { "<leader>a", group = "[A]vante AI" },
      { "<leader>b", group = "[B]uffer" },
      { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>g", group = "[G]it" },
      { "<leader>r", group = "[R]eference" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>u", group = "+Toggle" },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>t", group = "[T]rouble" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "<leader>x", group = "+Trouble" },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
