local registry = require("config.pack_registry")

local M = {}

local state = {
  loaded = {},
  loading = {},
  startup = {
    active = false,
    finished = false,
    load_ns = 0,
    loaded = {},
  },
}

local function normalize_spec(spec)
  local out = vim.deepcopy(spec)
  local version = out.version
  if type(version) == "string" and (version:find("%*") or version:find("%dx") or version:find("x%.") or version:find("%.x")) then
    out.version = vim.version.range(version)
  end
  return out
end

local function count(tbl)
  local n = 0
  for _ in pairs(tbl) do
    n = n + 1
  end
  return n
end

function M.once(fn)
  local done = false
  return function(...)
    if done then
      return
    end
    done = true
    return fn(...)
  end
end

function M.defer(fn)
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.schedule(fn)
    end,
  })
end

function M.startup_begin()
  state.startup.active = true
  state.startup.finished = false
  state.startup.load_ns = 0
  state.startup.loaded = {}
end

function M.startup_finish()
  state.startup.active = false
  state.startup.finished = true
end

function M.command(name, load_fn, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, function(args)
    pcall(vim.api.nvim_del_user_command, name)
    load_fn()
    if opts.invoke then
      return opts.invoke(args)
    end

    local cmd = name .. (args.bang and "!" or "")
    if args.args ~= "" then
      cmd = cmd .. " " .. args.args
    end
    vim.cmd(cmd)
  end, {
    nargs = opts.nargs or "*",
    bang = opts.bang ~= false,
    desc = opts.desc,
    complete = opts.complete,
  })
end

function M.load(name)
  if state.loaded[name] or state.loading[name] then
    return
  end

  local spec = registry[name]
  assert(spec, "unknown pack spec: " .. name)
  local started = vim.uv.hrtime()
  state.loading[name] = true
  vim.pack.add({ normalize_spec(spec) })
  state.loading[name] = nil
  state.loaded[name] = true
  local elapsed = vim.uv.hrtime() - started
  if state.startup.active then
    state.startup.load_ns = state.startup.load_ns + elapsed
    state.startup.loaded[name] = true
  end
end

function M.load_many(names)
  for _, name in ipairs(names) do
    M.load(name)
  end
end

function M.is_loaded(name)
  return not not state.loaded[name]
end

function M.stats()
  return {
    count = count(registry),
    loaded = count(state.loaded),
    startup_loaded = count(state.startup.loaded),
    startup_ms = state.startup.load_ns / 1000000,
    startup_finished = state.startup.finished,
  }
end

function M.registry()
  return registry
end

return M
