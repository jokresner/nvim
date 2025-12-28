return {
  suggestion = {
    enabled = false,
    auto_trigger = false,
    hide_during_completion = true,
    keymap = {
      accept = false, -- handled by blink map
      next = "<C-j>",
      prev = "<C-p>",
    },
  },
  panel = { enabled = false },
  filetypes = { markdown = true, help = true },
  server_opts_overrides = { settings = { telemetry = { telemetryLevel = "off" } } },
}
