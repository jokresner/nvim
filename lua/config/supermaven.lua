return {
  keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  ignore_filetypes = { cpp = true },
  color = {
    suggestion_color = "#888888",
    cterm = 244,
  },
  log_level = "info",
  disable_inline_completion = false, -- We want ghost text
  disable_keymaps = true, -- We will handle this in blink
}
