local yazi_id = 1337

local function yazi_emit(cmd, arg)
  if arg == "" then return end
  vim.fn.jobstart({"ya", "emit-to", yazi_id, cmd, "--srt", arg }, {detach = true})
end

vim.api.nvim_create_autocmd({"BufEnter"}, {
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
  if file == "" then return end
    yazi_emit("cd", vim.fn.fnamemodify(file, ":h")) -- change directory in yazi
    yazi_emit("reveal", file) -- select file in yazi
  end
})
