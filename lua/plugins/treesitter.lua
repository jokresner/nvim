local parsers = {
    "go",
    "gomod",
    "gosum",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "php",
    "query",
    "regex",
    "rust",
    "toml",
    "typst",
    "vim",
    "vimdoc",
    "yaml",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        cmd = { "TSInstall", "TSInstallFromGrammar", "TSLog", "TSUninstall", "TSUpdate" },
        build = function()
            local treesitter = require("nvim-treesitter")
            treesitter.install(parsers):wait(300000)
            treesitter.update(parsers):wait(300000)
        end,
        config = function()
            require("nvim-treesitter").setup()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("native_treesitter", { clear = true }),
                callback = function(event)
                    local ft = vim.bo[event.buf].filetype
                    local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
                    if ok and lang then
                        local parser_ok, parser_loaded = pcall(vim.treesitter.language.add, lang)
                        if not (parser_ok and parser_loaded) and vim.list_contains(parsers, lang) then
                            pcall(function()
                                require("nvim-treesitter").install({ lang }):wait(300000)
                            end)
                            parser_ok, parser_loaded = pcall(vim.treesitter.language.add, lang)
                        end
                        if parser_ok and parser_loaded then
                            pcall(vim.treesitter.start, event.buf, lang)
                        end
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            max_lines = 2,
            multiline_threshold = 1,
            mode = "cursor",
            separator = "-",
        },
    },
}
