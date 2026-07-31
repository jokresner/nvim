local function augroup(name)
    return vim.api.nvim_create_augroup("nvim_custom_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = { "help", "man", "qf", "checkhealth", "lspinfo" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Close window",
        })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w+://") then
            return
        end
        local path = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(path, ":p:h"), "p")
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("deferred_filetype_detect"),
    callback = function(event)
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) or vim.bo[event.buf].filetype ~= "" then
                return
            end

            local ft, on_detect, is_fallback = vim.filetype.match({
                filename = event.file,
                buf = event.buf,
            })
            if not ft then
                return
            end

            if on_detect then
                on_detect(event.buf)
            end
            vim.api.nvim_buf_call(event.buf, function()
                vim.api.nvim_cmd({
                    cmd = "setf",
                    args = is_fallback and { "FALLBACK", ft } or { ft },
                }, {})
            end)
        end)
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(event.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup("clean_term"),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.scrolloff = 0
    end,
})
