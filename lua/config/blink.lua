return {
  keymap = { preset = "enter" },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = false, auto_show_delay_ms = 200 },
    ghost_text = { enabled = vim.g.ai_cmp },
    menu = { draw = { treesitter = { "lsp" } } },
  },
  sources = {
    default = { "avante", "lsp", "path", "buffer" },
    providers = {
      avante = { module = "blink-cmp-avante", name = "Avante" },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  cmdline = { enabled = false },
}
