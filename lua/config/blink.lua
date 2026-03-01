-- Cache AI suggestion modules
local supermaven_preview = nil
local copilot_suggestion = nil

local function get_supermaven()
  if supermaven_preview == nil then
    local ok, sm = pcall(require, "supermaven-nvim.completion_preview")
    supermaven_preview = ok and sm or false
  end
  return supermaven_preview
end

local function get_copilot()
  if copilot_suggestion == nil then
    local ok, cop = pcall(require, "copilot.suggestion")
    copilot_suggestion = ok and cop or false
  end
  return copilot_suggestion
end

-- Hide AI ghost text when Blink's completion menu is open
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
      function(cmp) -- Tab key AI completion
        local sm = get_supermaven()
        if sm and sm.has_suggestion() then
          vim.schedule(function()
            sm.on_accept_suggestion()
          end)
          return true
        end

        local cop = get_copilot()
        if cop and cop.is_visible() then
          cop.accept()
          return true
        end
      end,
      "select_next", -- Select next item if completion menu is open
      "snippet_forward",
      "fallback", -- fallback to normal behavior (insert Tab)
    },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<c-j>"] = { "select_next", "fallback" },
    ["<c-k>"] = { "select_prev", "fallback" },
    ["<c-b>"] = { "scroll_documentation_up", "fallback" },
    ["<c-f>"] = { "scroll_documentation_down", "fallback" },
    ["<c-space>"] = { "show", "show_documentation", "fallback" },
    ["<c-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" }, -- Accept currently selected item, or fallback to default behavior.
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = false, auto_show_delay_ms = 200 },
    ghost_text = { enabled = false }, -- Copilot handles ghost text
    menu = { draw = { treesitter = { "lsp" } } },
  },
  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
    providers = {
      snippets = {
        opts = {
          search_paths = { vim.fn.stdpath "config" .. "/snippets" },
        },
      },
    },
  },
  fuzzy = { implementation = "prefer_rust" },
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
