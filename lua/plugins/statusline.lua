return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local theme = "auto"
            if pcall(require, "lualine.themes.catppuccin") then
                theme = "catppuccin"
            end

            local function lsp_name()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    return ""
                end

                local names = {}
                for _, client in ipairs(clients) do
                    if client.name ~= "null-ls" and client.name ~= "conform" then
                        names[#names + 1] = client.name
                    end
                end
                return table.concat(names, "+")
            end

            return {
                options = {
                    theme = theme,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            source = function()
                                local gs = vim.b.gitsigns_status_dict
                                if gs then
                                    return { added = gs.added, modified = gs.changed, removed = gs.removed }
                                end
                            end,
                        },
                    },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "diagnostics", lsp_name, "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            }
        end,
    },
}
