local M = {}

M.catppuccin = {
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    treesitter = true,
    notify = false,
    mini = { enabled = true, indentscope_color = "" },
    overseer = true,
  },
  background = { light = "latte", dark = "mocha" },
}

M.kanagawa = {
  transparent = true,
  colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
}

M.dressing = {
  input = { default_prompt = ">" },
  select = { backend = { "nui", "builtin" } },
}

M.which_key = {
  preset = "modern",
  delay = 500,
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  spec = {
    -- Top-level single keys
    { "<leader><space>", desc = "Smart Find Files" },
    { "<leader>,", desc = "Buffers" },
    { "<leader>/", desc = "Grep" },
    { "<leader>:", desc = "Command History" },
    { "<leader>.", desc = "Scratch Buffer" },
    { "<leader>-", desc = "Oil File Manager" },
    { "<leader>?", desc = "DAP Eval" },
    { "<leader>e", desc = "File Explorer" },
    { "<leader>z", desc = "Zen Mode" },
    { "<leader>Z", desc = "Zoom" },
    { "<leader>S", desc = "Select Scratch" },
    -- Groups
    { "<leader>a", group = "AI/Assistant" },
    { "<leader>b", group = "Buffers" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug" },
    { "<leader>dv", group = "DAP View" },
    { "<leader>ds", group = "Step" },
    { "<leader>du", group = "DAP UI" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Hunks" },
    { "<leader>l", group = "LSP" },
    { "<leader>m", group = "Test" },
    { "<leader>p", desc = "Paste from clipboard" },
    { "<leader>q", group = "Session" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Toggle/Tab/Terminal" },
    { "<leader>u", group = "UI Toggles" },
    { "<leader>v", group = "Visits" },
    { "<leader>w", group = "Workspace" },
    { "<leader>x", group = "Tasks/Diagnostics" },
    { "<leader>y", desc = "Copy to clipboard" },
    { "g", group = "Go to" },
  },
}

M.fold_cycle = function()
  vim.o.foldmethod = "indent"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  require("fold-cycle").setup(require("config.ui").fold_cycle)
end

M.indentscope = {
  symbol = "│",
  options = { try_as_border = true },
}

M.animate = function()
  local animate = require "mini.animate"
  return {
    cursor = {
      enable = true,
      timing = animate.gen_timing.linear { duration = 80, unit = "total" },
    },
    scroll = {
      enable = true,
      timing = animate.gen_timing.linear { duration = 100, unit = "total" },
      -- Disable animation for large jumps (gg, G, Ctrl-D, Ctrl-U, etc)
      subscroll = animate.gen_subscroll.equal {
        predicate = function(total_scroll)
          return total_scroll > 1 and total_scroll < 50
        end,
      },
    },
    resize = {
      enable = true,
      timing = animate.gen_timing.linear { duration = 50, unit = "total" },
    },
    open = { enable = false },
    close = { enable = false },
  }
end

M.hipatterns = function()
  local hipatterns = require "mini.hipatterns"
  return { highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } }
end

M.statuscol = function()
  local builtin = require "statuscol.builtin"
  return {
    segments = {
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      { text = { " %s" }, click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
    },
  }
end

M.fidget = {
  progress = { suppress_on_insert = true },
}

M.diagflow = {
  { scope = "line", padding_right = 2 },
}

M.noice = {
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
  cmdline = { view = "cmdline" },
  notify = { enabled = true },
}

function footer()
  local version = vim.version()
    local lazy_ok, lazy = pcall(require, "lazy")
    local startup_ms = 0
    
    if vim.g.start_time then
      -- Calculate elapsed time in milliseconds
      startup_ms = (vim.loop.hrtime() - vim.g.start_time) / 1000000
    end
    
    if lazy_ok then
      local stats = lazy.stats()
      return string.format(
        "Neovim v%d.%d.%d | %d/%d Plugins | Startup %.2fms",
        version.major, version.minor, version.patch,
        stats.loaded, stats.count,
        startup_ms
      )
    else
      return string.format("Neovim v%d.%d.%d | Startup %.2fms", version.major, version.minor, version.patch, startup_ms)
    end
  end

local Snacks = require "snacks"
M.starter = {
  footer = footer,
  header = table.concat({
    [[     __        __                                               ]],
    [[    |__| ____ |  | _________   ____   ______ ____   ___________ ]],
    [[    |  |/  _ \|  |/ /\_  __ \_/ __ \ /  ___//    \_/ __ \_  __ \]],
    [[    |  (  <_> )    <  |  | \/\  ___/ \___ \|   |  \  ___/|  | \/]],
    [[/\__|  |\____/|__|_ \ |__|    \___  >____  >___|  /\___  >__|   ]],
    [[\______|           \/             \/     \/     \/     \/       ]],
  }, "\n"),
  items = {
    { action = Snacks.picker.smart, name = "F:   Find File", section = "File" },
    { action = Snacks.picker.recent, name = "R:   Recent Files", section = "File" },
    { action = Snacks.picker.grep_word, name = "W:   Find Word", section = "Search" },
    { action = Snacks.picker.grep, name = "G:   Grep", section = "Search" },
    { action = "Lazy", name = "L: 󰒲  Lazy", section = "Plugins" },
    { action = "q", name = "Q:   Quit", section = "Exit" },
  },
  evaluate_single = true,
}

return M
