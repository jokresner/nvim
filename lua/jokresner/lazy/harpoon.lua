return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set('n', '<C-a>', function() harpoon:list():append() end, { desc = "[H]arpoon [A]ppend" })
    vim.keymap.set('n', '<C-d>', function() harpoon:list():remove() end, { desc = "[H]arpoon [R]emove" })
    vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end, { desc = "Harpoon toggle quick menu" })
    vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end, { desc = "Harpoon select first entity" })
    vim.keymap.set('n', '<C-h>', function() harpoon:list():select(2) end, { desc = "Harpoon select second entity" })
    vim.keymap.set('n', '<C-h>', function() harpoon:list():select(3) end, { desc = "Harpoon select third entity" })
    vim.keymap.set('n', '<C-h>', function() harpoon:list():select(4) end, { desc = "Harpoon select fourth entity" })

    vim.keymap.set('n', '<C-h-p', function() harpoon:list():prev() end, { desc = "Harpoon goto previous in list" })
    vim.keymap.set('n', '<C-h-n', function() harpoon:list():next() end, { desc = "Harpoon goto next in list" })
  end
}
