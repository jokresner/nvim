-- Theme state. Two sources, one owner:
--   external  ~/.local/state/theme/current.json, written by theme-apply.nu on the Linux desktop:
--             `variant` is dark/light and `ports.nvim` is the colorscheme. When it exists it wins.
--   cache     <stdpath state>/theme_cache.json { background, colorscheme }, written on every
--             ColorScheme event so the last background and colorscheme (also from the picker)
--             survive a restart. Read before any colorscheme loads to avoid a wrong-background flash.
-- Legacy <state>/bg_state (just "dark"/"light") is still read when no cache exists.
local M = {}

M.default_colorscheme = "catppuccin"

function M.external_path()
    return (vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")) .. "/theme/current.json"
end

function M.has_external()
    return vim.uv.fs_stat(M.external_path()) ~= nil
end

local function valid_background(bg)
    return bg == "dark" or bg == "light"
end

--- Logical colorscheme name. catppuccin with flavour "auto" reports the resolved flavour
--- ("catppuccin-mocha"); re-applying that would pin the flavour and ignore 'background'.
function M.logical_name(colors_name)
    if colors_name and colors_name:match("^catppuccin%-") then
        return "catppuccin"
    end
    return colors_name
end

--- Parse the external state file. A half-written file yields nil (the next change event retries).
---@return { background: string, colorscheme: string }|nil
function M.parse_external(text)
    local ok, state = pcall(vim.json.decode, text or "")
    if not ok or type(state) ~= "table" or type(state.ports) ~= "table" or type(state.ports.nvim) ~= "string" then
        return nil
    end
    return { background = state.variant == "light" and "light" or "dark", colorscheme = state.ports.nvim }
end

local function read_file(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local text = f:read("*a")
    f:close()
    return text
end

--- Read the cache from `dir`. Always returns a table; invalid fields are dropped.
---@return { background?: string, colorscheme?: string }
function M.read_cache(dir)
    local cache = {}
    local text = read_file(dir .. "/theme_cache.json")
    if text then
        local ok, decoded = pcall(vim.json.decode, text)
        if ok and type(decoded) == "table" then
            if valid_background(decoded.background) then
                cache.background = decoded.background
            end
            if type(decoded.colorscheme) == "string" and decoded.colorscheme ~= "" then
                cache.colorscheme = decoded.colorscheme
            end
            return cache
        end
    end
    local legacy = read_file(dir .. "/bg_state")
    if valid_background(legacy) then
        cache.background = legacy
    end
    return cache
end

function M.write_cache(dir, cache)
    vim.fn.mkdir(dir, "p")
    local f = io.open(dir .. "/theme_cache.json", "w")
    if f then
        f:write(vim.json.encode(cache))
        f:close()
    end
end

--- Set 'background' from the cache. Call before any colorscheme loads; requires no plugin.
function M.preseed(dir)
    local cache = M.read_cache(dir)
    if cache.background then
        vim.o.background = cache.background
    end
end

--- Save background and colorscheme on every ColorScheme event (picker, auto-dark-mode, external).
function M.remember(dir)
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("core_theme_remember", { clear = true }),
        callback = function()
            if valid_background(vim.o.background) and vim.g.colors_name then
                M.write_cache(dir, { background = vim.o.background, colorscheme = M.logical_name(vim.g.colors_name) })
            end
        end,
    })
end

--- Apply the cached (or default) colorscheme.
function M.restore(dir)
    local name = M.read_cache(dir).colorscheme or M.default_colorscheme
    if not pcall(vim.cmd.colorscheme, name) then
        pcall(vim.cmd.colorscheme, M.default_colorscheme)
    end
end

--- Switch background and re-apply the current colorscheme (auto-dark-mode callbacks).
function M.set_background(bg)
    vim.o.background = bg
    pcall(vim.cmd.colorscheme, M.logical_name(vim.g.colors_name) or M.default_colorscheme)
end

--- Apply the external state file. Returns true when it was applied.
function M.apply_external()
    local text = read_file(M.external_path())
    local state = text and M.parse_external(text)
    if not state then
        return false
    end
    vim.o.background = state.background
    pcall(vim.cmd.colorscheme, state.colorscheme)
    return true
end

-- theme-apply.nu rewrites the file in place, so a plain file watch keeps working.
function M.watch_external()
    local watcher = vim.uv.new_fs_event()
    if not watcher then
        return
    end
    watcher:start(
        M.external_path(),
        {},
        vim.schedule_wrap(function()
            M.apply_external()
        end)
    )
end

--- Startup: remember changes, then external state if present, else the cached colorscheme.
function M.setup(dir)
    M.remember(dir)
    if M.has_external() then
        M.restore(dir) -- fallback until the external file is applied
        M.apply_external()
        M.watch_external()
    else
        M.restore(dir)
    end
end

return M
