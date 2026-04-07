local state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "context_mode.txt")
local reading_filetypes = {
  markdown = true,
  text = true,
  help = true,
  man = true,
  gitcommit = true,
}

local ui_snapshot = {
  relativenumber = vim.o.relativenumber,
  cursorline = vim.o.cursorline,
}

local function read_mode()
  if vim.fn.filereadable(state_file) == 0 then
    return "compact"
  end
  local lines = vim.fn.readfile(state_file)
  local mode = lines[1]
  if mode == "compact" or mode == "reading" then
    return mode
  end
  return "compact"
end

local function write_mode(mode)
  vim.fn.mkdir(vim.fn.stdpath("state"), "p")
  vim.fn.writefile({ mode }, state_file)
end

local context_mode = read_mode()
vim.g.context_mode = context_mode
vim.g.context_mode_manual = false

local function set_winbar_for_window(win)
  pcall(vim.api.nvim_set_option_value, "winbar", "", { win = win })
end

local function set_mode_ui(mode)
  if mode == "reading" then
    vim.o.relativenumber = false
    vim.o.cursorline = false
    return
  end
  vim.o.relativenumber = ui_snapshot.relativenumber
  vim.o.cursorline = ui_snapshot.cursorline
end

local function apply_winbar()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    set_winbar_for_window(win)
  end
end

local function set_context_mode(mode, opts)
  opts = opts or {}
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    pcall(lazy.load, { plugins = { "nvim-navic", "nvim-treesitter-context" } })
  end

  local ok_context, ts_context = pcall(require, "treesitter-context")
  if mode == "compact" then
    if ok_context then
      ts_context.enable()
    end
  else
    if ok_context then
      ts_context.disable()
    end
  end

  set_mode_ui(mode)
  apply_winbar()

  context_mode = mode
  vim.g.context_mode = mode
  write_mode(mode)

  if not opts.silent then
    vim.notify("Context mode: " .. mode, vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command("ContextModeToggle", function()
  vim.g.context_mode_manual = true
  if context_mode == "compact" then
    set_context_mode("reading")
  else
    set_context_mode("compact")
  end
end, { desc = "Toggle compact/reading context mode" })

vim.api.nvim_create_user_command("ContextMode", function(args)
  vim.g.context_mode_manual = true
  local mode = args.args
  if mode ~= "compact" and mode ~= "reading" then
    vim.notify("Use :ContextMode compact|reading", vim.log.levels.WARN)
    return
  end
  set_context_mode(mode)
end, {
  nargs = 1,
  complete = function()
    return { "compact", "reading" }
  end,
  desc = "Set compact/reading context mode",
})

vim.api.nvim_create_user_command("ContextModeAuto", function()
  vim.g.context_mode_manual = false
  local ft = vim.bo.filetype
  if reading_filetypes[ft] then
    set_context_mode("reading")
  else
    set_context_mode("compact")
  end
end, { desc = "Re-enable auto context mode by filetype" })

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("user_context_mode", { clear = true }),
  callback = function()
    set_context_mode(vim.g.context_mode or context_mode, { silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "user_context_mode",
  callback = function(event)
    if vim.g.context_mode_manual then
      return
    end
    local ft = vim.bo[event.buf].filetype
    if reading_filetypes[ft] then
      set_context_mode("reading", { silent = true })
    else
      set_context_mode("compact", { silent = true })
    end
  end,
})
