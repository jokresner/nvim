return {
  { "nvim-mini/mini.comment", event = "VeryLazy", opts = {} },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
  },
  { "nvim-mini/mini.ai", event = "VeryLazy", opts = {} },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    opts = {},
    keys = {
      { "<leader>ct", function() require("snacks").picker.todo_comments() end, desc = "Code todos" },
      {
        "<leader>cT",
        function()
          require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Code todo+fix",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search replace files" },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        desc = "Refactor selection",
      },
    },
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash treesitter search" },
      { "<C-s>", mode = "c", function() require("flash").toggle() end, desc = "Flash toggle search" },
    },
  },
}
