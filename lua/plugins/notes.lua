local vaults_root = os.getenv "OBSIDIAN_VAULTS" or vim.fn.expand "~/vaults"

local function open_vault_in_floating_nvim(path)
  require("snacks").terminal("nvim .", {
    cwd = path,
    on_close = function()
      if #vim.api.nvim_list_wins() ~= 1 then
        return
      end
      local buf = vim.api.nvim_get_current_buf()
      local name = vim.api.nvim_buf_get_name(buf)
      local buftype = vim.bo[buf].buftype
      local modified = vim.bo[buf].modified
      if name == "" and buftype == "" and not modified then
        vim.cmd "quit"
      end
    end,
  })
end

return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "quarto", "rmd", "typst" },
    opts = {
      split_nav = {
        enable = true,
        split_type = "vertical",
        split_size = "50%",
      },
    },
    keys = {
      { "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Markdown preview split" },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. vaults_root .. "/**/*.md",
      "BufNewFile " .. vaults_root .. "/**/*.md",
    },
    cmd = { "Obsidian" },
    dependencies = { "folke/snacks.nvim" },
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "personal", path = vaults_root .. "/personal" },
        { name = "htwk", path = vaults_root .. "/htwk" },
        { name = "work", path = vaults_root .. "/work" },
      },
      daily_notes = {
        folder = "daily",
        date_format = "%d.%m.%Y",
      },
    },
    keys = {
      {
        "<leader>op",
        function()
          open_vault_in_floating_nvim(vaults_root .. "/personal")
        end,
        desc = "Obsidian open personal",
      },
      {
        "<leader>oh",
        function()
          open_vault_in_floating_nvim(vaults_root .. "/htwk")
        end,
        desc = "Obsidian open htwk",
      },
      {
        "<leader>ow",
        function()
          open_vault_in_floating_nvim(vaults_root .. "/work")
        end,
        desc = "Obsidian open work",
      },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian new" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian search" },
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian quick switch" },
      {
        "<leader>oo",
        function()
          require("snacks").picker.select({ "personal", "htwk", "work" }, { prompt = "Select Vault" }, function(vault)
            if not vault then
              return
            end
            vim.cmd("vsplit " .. vaults)
          end)
        end,
        desc = "Obsidian daily note split",
      },
    },
  },
}
