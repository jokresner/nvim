-- Neovim 0.12+ minimal init using built-in vim.pack and built-ins where possible
vim.g._nvim_start_hrtime = vim.g._nvim_start_hrtime or ((vim.uv and vim.uv.hrtime) and vim.uv.hrtime() or (vim.loop and vim.loop.hrtime and vim.loop.hrtime()) or nil)
vim.g.mapleader = " "

-- Minimal plugin set via built-in manager (requires git >= 2.36)
vim.pack.add({
  -- Core
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- Completion & snippets
  "https://github.com/saghen/blink.cmp",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/giuxtaposition/blink-cmp-copilot",
  "https://github.com/kaiser-Yang/blink-cmp-avante",
  "https://github.com/L3MON4D3/LuaSnip",

  -- Telescope
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/mikavilpas/yazi.nvim",

  -- UI/UX
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/echasnovski/mini.statusline",

  -- Colorschemes
  "https://github.com/catppuccin/nvim",
  "https://github.com/rebelot/kanagawa.nvim",

  -- Comments
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",

  -- DAP & tools
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/leoluz/nvim-dap-go",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-neotest/neotest",

  -- DB
  "https://github.com/kndndrj/nvim-dbee",
  "https://github.com/MunifTanjim/nui.nvim",

  -- AI & helpers
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/yetone/avante.nvim",
  "https://github.com/ravitemer/mcphub.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/folke/snacks.nvim",

  -- Misc
  "https://github.com/folke/noice.nvim",
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/alex-popov-tech/store.nvim",
  "https://github.com/vimichael/floatingtodo.nvim",
  "https://github.com/danymat/neogen",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/mrcjkb/rustaceanvim",
  "https://github.com/dmmulroy/ts-error-translator.nvim",
})

-- Core configs
pcall(require, "config.lsp")
pcall(require, "config.treesitter")
pcall(require, "config.completion")
pcall(require, "config.git")
pcall(require, "config.whichkey")
pcall(require, "config.statusline")
pcall(require, "config.comments")
pcall(require, "config.snippets")
pcall(require, "config.snacks")
pcall(require, "config.dap")

-- Colorscheme (built-in)
pcall(vim.cmd.colorscheme, "catppuccin")
