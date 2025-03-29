local data = assert(vim.fn.stdpath "data") --[[@as string]]

require("telescope").setup {
  extensions = {
    wrap_results = true,

    fzf = {},
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<space>fd", builtin.find_files, { desc = "Find in directory" })
vim.keymap.set("n", "<space>ft", function()
  return builtin.git_files { cwd = vim.fn.expand "%:h" }
end, { desc = "Find git files" })
vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<space>fg", require "config.telescope.multigrep", { desc = "Find grep" })
vim.keymap.set("n", "<space>fb", builtin.buffers, { desc = "Find buffer" })
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find, { desc = "Find in current buffer" })

vim.keymap.set("n", "<space>gw", builtin.grep_string, { desc = "Grep word" })

