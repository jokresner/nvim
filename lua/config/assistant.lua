local M = {}

M.sidekick = {
  cli = {
    mux = {
      backend = "zellij",
      enabled = true,
    },
  },
}

M.mcphub = {
  extensions = {
    sidekick = {
      make_slash_commands = true,
    },
  },
}

return M
