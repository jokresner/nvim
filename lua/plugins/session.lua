return {
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = vim.opt.sessionoptions:get() },
        init = function()
            -- Auto-restore session if nvim is started without arguments
            vim.api.nvim_create_autocmd("VimEnter", {
                group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
                nested = true,
                callback = function()
                    -- Only restore if opening without arguments
                    if vim.fn.argc() == 0 then
                        require("persistence").load()
                    end
                end,
            })
        end,
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore last session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't save current session",
            },
            {
                "<leader>qx",
                function()
                    local file = require("persistence").current()
                    if file and vim.fn.filereadable(file) == 1 then
                        vim.fn.delete(file)
                        vim.notify("Deleted session for " .. vim.fn.getcwd(), vim.log.levels.INFO)
                    end
                    require("persistence").stop()
                end,
                desc = "Delete current session",
            },
            {
                "<leader>qX",
                function()
                    local persistence = require("persistence")
                    local project_session = persistence.current({ branch = false })
                    local base = project_session:sub(1, -5)
                    local sessions = vim.list_extend(
                        vim.fn.glob(project_session, true, true),
                        vim.fn.glob(base .. "%%*.vim", true, true)
                    )

                    for _, session in ipairs(sessions) do
                        vim.fn.delete(session)
                    end
                    persistence.stop()
                    vim.notify("Deleted " .. #sessions .. " session(s) for " .. vim.fn.getcwd(), vim.log.levels.INFO)
                end,
                desc = "Delete project sessions",
            },
            {
                "<leader>qS",
                function()
                    require("persistence").select()
                end,
                desc = "Select session",
            },
        },
    },
}
