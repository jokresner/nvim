local M = {}

M.setup = {
  sources = {
    require("dbee.sources").FileSource:new(vim.fn.stdpath "cache" .. "/dbee/persistence.json"),
  },
}

return M


