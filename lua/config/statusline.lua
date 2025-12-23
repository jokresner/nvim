local M = {}

M.lualine = {
  options = {
    theme = "catppuccin",
    component_separators = "|",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2 },
    },
    lualine_b = { "filename", "branch" },
    lualine_c = { "fileformat" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = {
      { "location", separator = { right = "" }, left_padding = 2 },
    },
  },
}

M.bufferline = function()
  return {
    options = {
      mode = "buffers",
      separator_style = "slant",
      hover = { enabled = true, delay = 200, reveal = { "close" } },
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },
      groups = {
        items = {
          require("bufferline.groups").builtin.pinned:with { icon = "" },
        },
      },
    },
  }
end

return M
