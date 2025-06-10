local Snacks = require "snacks"

local M = {}

local uv = vim.uv or vim.loop

local function get_cmd(opts, filter)
  local pattern = Snacks.picker.util.parse(filter.search)

  local cmd = "ast-grep"
  local args = {
    "-p",
    pattern,
    "--json",
  }

  local paths = {}

  if opts.buffers then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and vim.bo[buf].buflistged and uv.fs_stat(name) then
        paths[#paths + 1] = name
      end
    end
  end

  vim.list_extend(paths, opts.dirs or {})
  if opts.rtp then
    vim.list_extend(paths, Snacks.picker.util.rtp())
  end

  if #paths > 0 then
    paths = vim.tbl_map(svim.fs.normalize, paths)
    vim.list_extend(args, paths)
  end

  return cmd, args
end

function M.ast_grep_picker(opts, ctx)
  if opts.need_search ~= false and ctx.filter.search == "" then
    return function() end
  end

  local absolute = (opts.dirs and #opts.dirs > 0) or opts.buffers or opts.rtp
  local cwd = not absolute and svim.fs.normalize(opts and opts.cwd or uv.cwd() or ".") or nil
  local cmd, args = get_cmd(opts, ctx.filter)

  return require("snacks.picker.source.proc").proc({
    opts,
    {
      notify = false,
      cmd = cmd,
      args = args,
      transform = function(item)
        item.cwd = cwd
        local file, line, col, text = item.text:match "^(.+):(%d+):(%d+):(.*)$"
        if not file then
          if not item.text:match "WARNING" then
            snacks.notify.error("invalid ast-grep output:\n" .. item.text)
          end
          return false
        else
          item.line = text
          item.file = file
          item.pos = { tonumber(line), tonumber(col) - 1 }
        end
      end,
    },
  }, ctx)
end

return M
