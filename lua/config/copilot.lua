return {
  suggestion = {
    enabled = not vim.g.ai_cmp,
    auto_trigger = true,
    hide_during_completion = vim.g.ai_cmp,
    keymap = {
      accept = false,
      next = "<C-j>",
      prev = "<C-p>",
    },
  },
  panel = { enabled = false },
  filetypes = { markdown = true, help = true },
  server_opts_overrides = { settings = { telemetry = { telemetryLevel = "off" } } },
  disabled_tools = {
    "list_files",
    "search_files",
    "read_file",
    "create_file",
    "rename_file",
    "delete_file",
    "create_dir",
    "rename_dir",
    "delete_dir",
    "bash",
  },
}
