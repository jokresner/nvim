-- Hide Copilot ghost text when Blink's completion menu is open (prevents visual overlap)
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

return {
  keymap = {
    ["<Tab>"] = {
      function(cmp) -- Tab key copilot completion
        local ok, cop = pcall(require, "copilot.suggestion")
        if ok and cop.is_visible() then
          cop.accept()
          return true
        end
      end,
      function(cmp) -- VSCode style accept behavior
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback", -- fallback to normal behavior (insert Tab)
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    ["<c-j>"] = { "select_next", "fallback" },
    ["<c-k>"] = { "select_prev", "fallback" },
    ["<c-b>"] = { "scroll_documentation_up", "fallback" },
    ["<c-f>"] = { "scroll_documentation_down", "fallback" },
    ["<c-space>"] = { "show", "show_documentation", "fallback" },
    ["<c-e>"] = { "hide", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = false, auto_show_delay_ms = 200 },
    ghost_text = { enabled = vim.g.ai_cmp },
    menu = { draw = { treesitter = { "lsp" } } },
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
    providers = {
      snippets = {},
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  cmdline = {
    enabled = true,
    sources = function()
      local type = vim.fn.getcmdtype()
      -- Search forward/backward
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      -- Commands
      if type == ":" then
        return { "cmdline" }
      end
      return {}
    end,
  },
}
