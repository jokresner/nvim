return {
    {
        "rebelot/heirline.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.opt.showtabline = 2
            
            local conditions = require("heirline.conditions")
            local utils = require("heirline.utils")
            
            local function setup_colors()
                return {
                    bg = utils.get_highlight("StatusLine").bg,
                    fg = utils.get_highlight("StatusLine").fg,
                    mantle = utils.get_highlight("NormalFloat").bg or "#181825",
                    crust = utils.get_highlight("FloatBorder").bg or "#11111b",
                    base = utils.get_highlight("Normal").bg or "#1e1e2e",
                    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
                    diag_error = utils.get_highlight("DiagnosticError").fg,
                    diag_hint = utils.get_highlight("DiagnosticHint").fg,
                    diag_info = utils.get_highlight("DiagnosticInfo").fg,
                    git_del = utils.get_highlight("diffDeleted").fg,
                    git_add = utils.get_highlight("diffAdded").fg,
                    git_change = utils.get_highlight("diffChanged").fg,
                    subtext0 = utils.get_highlight("Comment").fg or "#a6adc8",
                    subtext1 = utils.get_highlight("String").fg or "#bac2de",
                    active_fg = utils.get_highlight("Function").fg or "#89b4fa",
                    active_bg = utils.get_highlight("Visual").bg or "#313244",
                    blue = utils.get_highlight("Function").fg or "#89b4fa",
                    green = utils.get_highlight("String").fg or "#a6e3a1",
                    mauve = utils.get_highlight("Statement").fg or "#cba6f7",
                    orange = utils.get_highlight("Constant").fg or "#fab387",
                    purple = utils.get_highlight("Keyword").fg or "#cba6f7",
                    red = utils.get_highlight("Error").fg or "#f38ba8",
                }
            end
            
            require("heirline").load_colors(setup_colors())

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    utils.on_colorscheme(setup_colors())
                end,
            })

            local Align = { provider = "%=" }
            local Space = { provider = " " }

            local ViMode = {
                init = function(self)
                    self.mode = vim.fn.mode(1)
                end,
                static = {
                    mode_names = {
                        n = "N", no = "N?", nov = "N?", noV = "N?", ["no\22"] = "N?", niI = "Ni", niR = "Nr", niV = "Nv",
                        nt = "Nt", v = "V", vs = "Vs", V = "V_", Vs = "Vs", ["\22"] = "^V", ["\22s"] = "^V",
                        s = "S", S = "S_", ["\19"] = "^S", i = "I", ic = "Ic", ix = "Ix", R = "R", Rc = "Rc",
                        Rx = "Rx", Rv = "Rv", Rvc = "Rv", Rvx = "Rv", c = "C", cv = "Ex", r = "...", rm = "M",
                        ["r?"] = "?", ["!"] = "!", t = "T",
                    },
                    mode_colors = {
                        n = "blue", i = "green", v = "mauve", V = "mauve", ["\22"] = "mauve",
                        c = "orange", s = "purple", S = "purple", ["\19"] = "purple",
                        R = "red", r = "red", ["!"] = "red", t = "red",
                    }
                },
                provider = function(self)
                    return " " .. self.mode_names[self.mode] .. " "
                end,
                hl = function(self)
                    local mode = self.mode:sub(1, 1)
                    return { fg = self.mode_colors[mode] or "fg", bold = true }
                end,
                update = { "ModeChanged" },
            }

            local FileNameBlock = {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(0)
                end,
            }

            local FileIcon = {
                init = function(self)
                    local filename = self.filename
                    local extension = vim.fn.fnamemodify(filename, ":e")
                    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
                end,
                provider = function(self)
                    return self.icon and (self.icon .. " ")
                end,
                hl = function(self)
                    return { fg = self.icon_color }
                end
            }

            local FileName = {
                provider = function(self)
                    if self.filename == "" then return "[No Name]" end

                    local root = vim.fs.root(self.filename, ".git")
                    local filename = root and self.filename:sub(#root + 2) or vim.fn.fnamemodify(self.filename, ":t")
                    if not conditions.width_percent_below(#filename, 0.25) then
                        filename = vim.fn.pathshorten(filename)
                    end
                    return filename
                end,
                hl = { fg = "fg" },
            }

            local FileFlags = {
                {
                    condition = function() return vim.bo.modified end,
                    provider = " [+]",
                    hl = { fg = "green" },
                },
                {
                    condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
                    provider = " ",
                    hl = { fg = "orange" },
                },
            }

            FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, { provider = "%<" })

            local Diagnostics = {
                condition = conditions.has_diagnostics,
                static = {
                    error_icon = "● ",
                    warn_icon = "◆ ",
                    info_icon = "■ ",
                    hint_icon = "▲ ",
                },
                init = function(self)
                    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
                end,
                update = { "DiagnosticChanged", "BufEnter" },
                {
                    provider = function(self)
                        return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                    end,
                    hl = { fg = "diag_error" },
                },
                {
                    provider = function(self)
                        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                    end,
                    hl = { fg = "diag_warn" },
                },
            }

            local Git = {
                condition = conditions.is_git_repo,
                init = function(self)
                    self.status_dict = vim.b.gitsigns_status_dict or { added = 0, removed = 0, changed = 0, head = "" }
                    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
                end,
                hl = { fg = "fg" },
                {
                    provider = function(self)
                        return " " .. self.status_dict.head .. " "
                    end,
                    hl = { bold = true }
                },
            }

            local LSPActive = {
                condition = conditions.lsp_attached,
                update = { "LspAttach", "LspDetach" },
                provider = function()
                    local names = {}
                    for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                        if server.name ~= "null-ls" and server.name ~= "conform" then
                            table.insert(names, server.name)
                        end
                    end
                    return " " .. table.concat(names, " ") .. " "
                end,
                hl = { fg = "subtext1", bold = true },
            }

            local StatusLine = {
                hl = { bg = "crust", fg = "fg" },
                Space, ViMode, Space, FileNameBlock, Space, Git, Align, Diagnostics, LSPActive, Space
            }

            local ActiveTab = {
                hl = { bg = "active_fg", fg = "crust", bold = true },
                { provider = " " },
                {
                    init = function(self)
                        local filename = self.filename
                        local extension = vim.fn.fnamemodify(filename, ":e")
                        self.icon, _ = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
                    end,
                    provider = function(self) return self.icon and (self.icon .. " ") end,
                    hl = { fg = "crust" }
                },
                {
                    provider = function(self)
                        local filename = self.filename
                        return filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
                    end,
                    hl = { fg = "crust", bold = true }
                },
                {
                    condition = function(self) return vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) end,
                    provider = " [+]",
                    hl = { fg = "crust", bold = true }
                },
                { provider = " " },
            }

            local InactiveTab = {
                hl = { bg = "crust", fg = "subtext0" },
                { provider = " " },
                {
                    init = function(self)
                        local filename = self.filename
                        local extension = vim.fn.fnamemodify(filename, ":e")
                        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
                    end,
                    provider = function(self) return self.icon and (self.icon .. " ") end,
                    hl = function(self) return { fg = self.icon_color } end
                },
                {
                    provider = function(self)
                        local filename = self.filename
                        return filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
                    end,
                    hl = { fg = "subtext0" }
                },
                {
                    condition = function(self) return vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) end,
                    provider = " [+]",
                    hl = { fg = "diag_warn" }
                },
                { provider = " " },
            }

            local TablineFileNameBlock = {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
                    self.is_active = self.bufnr == vim.api.nvim_get_current_buf()
                end,
                { condition = function(self) return self.is_active end, ActiveTab },
                { condition = function(self) return not self.is_active end, InactiveTab },
            }

            local BufferLine = utils.make_buflist(
                TablineFileNameBlock,
                { provider = "  ", hl = "TabLine" },
                { provider = "  ", hl = "TabLine" }
            )

            local TabLine = { 
                BufferLine, 
                { provider = "%=", hl = "TabLineFill" },
                update = { "BufEnter", "WinEnter", "BufAdd", "BufDelete", "SessionLoadPost" }
            }

            vim.api.nvim_create_autocmd({ "SessionLoadPost", "BufEnter", "WinEnter" }, {
                group = vim.api.nvim_create_augroup("HeirlineTablineRedraw", { clear = true }),
                callback = function()
                    vim.schedule(function()
                        vim.cmd("redrawtabline")
                    end)
                end,
            })

            require("heirline").setup({
                statusline = StatusLine,
                tabline = TabLine,
            })
        end,
    }
}
