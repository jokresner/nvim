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
    snippets = {
      expand = function(body)
        require("snippy").expand_snippet(body)
      end,
    },
    default = { "avante", "lsp", "path", "snippets", "buffer", "copilot" },
    providers = {
      copilot = { name = "copilot", module = "blink-cmp-copilot", score_offset = 100, async = true },
      avante = { module = "blink-cmp-avante", name = "Avante" },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  cmdline = { enabled = false },
}
