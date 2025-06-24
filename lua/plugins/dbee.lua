return {
  {
    "kndndrj/nvim-dbee",
    cond = vim.g.vscode == nil,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup {
        sources = {
          require("dbee.sources").FileSource:new(vim.fn.stdpath "cache" .. "/dbee/persistence.json"),
        },
      }
    end,
    init = function()
      vim.api.nvim_create_user_command("DBee", function()
        require("dbee").open()
      end, { desc = "Open DBee" })
    end,
  },
}
