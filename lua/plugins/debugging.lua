local function define_signs()
    local sign = vim.fn.sign_define
    sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    sign("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    sign("DapBreakpointRejected", { text = "✖", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    sign("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "debugPC", numhl = "" })
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "igorlfs/nvim-dap-view" },
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle breakpoint",
            },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Conditional breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step into",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Step over",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Step out",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open()
                end,
                desc = "Open REPL",
            },
            {
                "<leader>dv",
                function()
                    require("dap-view").toggle()
                end,
                desc = "Toggle DAP view",
            },
        },
        -- Base DAP owns UI, signs, and keymaps. Language files add adapter setup
        -- callbacks through core.lang (`dap.setup`); adapters install via `tools`.
        opts = { adapters = {} },
        config = function(_, opts)
            for _, setup_adapter in ipairs(opts.adapters or {}) do
                setup_adapter(require("dap"))
            end
            define_signs()
            require("dap-view").setup({ auto_toggle = true })
        end,
    },
}
