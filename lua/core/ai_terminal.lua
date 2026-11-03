-- AI terminal: agent CLIs (hx, pi, ...) in Snacks terminals. Adding an agent is one entry in the
-- agent list passed to `new`; keymaps and edgy views are generated from it.
--
-- agent: { id = "hx", cmd = "hx", key = "a", title = "Hx" }
--   key is the suffix of <leader>a<key>
local M = {}

--- The one format for pointing at code: cwd-relative (or ~-relative) path, optional ":line".
function M.reference(path, line)
    local ref = vim.fn.fnamemodify(path, ":~:.")
    if line then
        ref = ref .. ":" .. line
    end
    return ref
end

--- edgy.nvim views for the agents (right side). Each view matches only its own terminal.
function M.edgy_views(agents, width)
    local views = {}
    for _, agent in ipairs(agents) do
        table.insert(views, {
            title = "AI (" .. agent.title .. ")",
            ft = "snacks_terminal",
            filter = function(buf)
                local terminal = vim.b[buf].snacks_terminal
                return terminal ~= nil and terminal.id == agent.id
            end,
            size = { width = width or 0.3 },
        })
    end
    return views
end

---@param opts { agents: table[], terminal: fun(cmd: string, opts: table): table, notify?: fun(msg: string, level: integer), send?: fun(job: integer, data: string) }
function M.new(opts)
    local notify = opts.notify or vim.notify
    local send = opts.send or vim.api.nvim_chan_send
    local self = { active = nil }

    local function find(id)
        for _, agent in ipairs(opts.agents) do
            if agent.id == id then
                return agent
            end
        end
    end

    function self.open(id)
        local agent = find(id)
        if not agent then
            notify("Unknown AI agent: " .. tostring(id), vim.log.levels.WARN)
            return
        end
        local terminal = opts.terminal(agent.cmd, {
            id = agent.id,
            win = { style = "terminal", border = "none", width = 0.3, position = "right" },
        })
        self.active = { id = agent.id, terminal = terminal }
    end

    --- Send text to the last opened agent. Returns true when it was sent.
    function self.send(message)
        local active = self.active
        if not active then
            notify("Open an AI agent first", vim.log.levels.WARN)
            return false
        end
        local terminal = active.terminal
        if not terminal or not vim.api.nvim_buf_is_valid(terminal.buf) then
            notify("AI agent is not running: " .. active.id, vim.log.levels.WARN)
            return false
        end
        local job = vim.b[terminal.buf].terminal_job_id
        if not job then
            notify("AI agent has no active terminal job: " .. active.id, vim.log.levels.WARN)
            return false
        end
        send(job, message)
        return true
    end

    function self.send_file()
        return self.send(M.reference(vim.fn.expand("%")))
    end

    function self.send_line()
        return self.send(M.reference(vim.fn.expand("%"), vim.fn.line(".")))
    end

    --- <leader>a<key> opens an agent; <leader>af / <leader>al send the file / line.
    function self.map_keys()
        for _, agent in ipairs(opts.agents) do
            vim.keymap.set("n", "<leader>a" .. agent.key, function()
                self.open(agent.id)
            end, { desc = "AI (" .. agent.title .. ")" })
        end
        vim.keymap.set("n", "<leader>af", self.send_file, { desc = "AI send file" })
        vim.keymap.set("n", "<leader>al", self.send_line, { desc = "AI send this line" })
    end

    return self
end

return M
