local supermaven_preview
local copilot_suggestion

local function get_supermaven()
  if supermaven_preview == nil then
    local ok, module = pcall(require, "supermaven-nvim.completion_preview")
    supermaven_preview = ok and module or false
  end
  return supermaven_preview
end

local function get_copilot()
  if copilot_suggestion == nil then
    local ok, module = pcall(require, "copilot.suggestion")
    copilot_suggestion = ok and module or false
  end
  return copilot_suggestion
end

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
    local sm = get_supermaven()
    if sm then
      sm.disable_inline_completion = true
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
    local sm = get_supermaven()
    if sm then
      sm.disable_inline_completion = false
    end
  end,
})

return {
  keymap = {
    ["<Tab>"] = {
      function()
        local sm = get_supermaven()
        if sm and sm.has_suggestion() then
          vim.schedule(sm.on_accept_suggestion)
          return true
        end
        local cop = get_copilot()
        if cop and cop.is_visible() then
          cop.accept()
          return true
        end
      end,
      "select_next",
      "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = false, auto_show_delay_ms = 200 },
    ghost_text = { enabled = false },
    menu = { draw = { treesitter = { "lsp" } } },
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
    providers = {
      snippets = {
        opts = {
          search_paths = { vim.fn.stdpath("config") .. "/snippets" },
        },
      },
    },
  },
  fuzzy = { implementation = "prefer_rust" },
  cmdline = {
    enabled = true,
    sources = function()
      local t = vim.fn.getcmdtype()
      if t == "/" or t == "?" then
        return { "buffer" }
      end
      if t == ":" then
        return { "cmdline" }
      end
      return {}
    end,
  },
}
