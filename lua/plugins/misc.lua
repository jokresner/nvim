return {
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
  {
    "alex-popov-tech/store.nvim",
  },
  {
    "vimichael/floatingtodo.nvim",
    config = function()
      require("floatingtodo").setup {
        target_file = "~/TODO.md",
        border = "single", -- single, rounded, etc.
        width = 0.8, -- width of window in % of screen size
        height = 0.8, -- height of window in % of screen size
        position = "center", -- topleft, topright, bottomleft, bottomright
      }
      vim.keymap.set("n", "<leader>td", ":Td<CR>", { desc = "Open Floating Todo" })
    end,
  },
}
