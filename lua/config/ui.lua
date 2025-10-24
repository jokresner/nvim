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

M.clue = function()
  local clue = require "mini.clue"
  return {
    setup = {
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "[" },
      },
      clues = {
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
        clue.gen_clues.g(),
      },
    },
  }
end

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

local function footer()
  local version = vim.version()
  return string.format("Neovim v%d.%d.%d", version.major, version.minor, version.patch)
end

local Snacks = require "snacks"
M.starter = {
  footer = footer(),
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
