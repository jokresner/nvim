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
        },
    },
}
