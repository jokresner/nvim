return {
  {
    "kndndrj/nvim-dbee",
    cond = vim.g.vscode == nil,
    cmd = "DBee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    opts = function()
      return require("config.dbee").setup
    end,
    init = function()
      vim.api.nvim_create_user_command("DBee", function()
        require("dbee").open()
      end, { desc = "Open DBee" })
    end,
  },
}
