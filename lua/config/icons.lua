local M = {}

M.setup = function()
  require("mini.icons").setup({})
  if not pcall(require, "nvim-web-devicons") then
    require("mini.icons").mock_nvim_web_devicons()
  end
end

return M


