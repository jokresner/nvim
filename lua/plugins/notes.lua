local runtime = require("config.pack_runtime")
local snacks = require("config.snacks")

local M = {}

local vaults_root = os.getenv("OBSIDIAN_VAULTS") or vim.fn.expand("~/vaults")

local function open_vault_in_floating_nvim(path)
  snacks.terminal("nvim .", {
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
        vim.cmd("quit")
      end
    end,
  })
end

function M.setup()
  local load_markview = runtime.once(function()
    runtime.load("markview")
    require("markview").setup({
      split_nav = {
        enable = true,
        split_type = "vertical",
        split_size = "50%",
      },
    })
  end)

  local load_obsidian = runtime.once(function()
    runtime.load_many({ "snacks", "obsidian" })
    require("obsidian").setup({
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
    })
  end)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "quarto", "rmd", "typst" },
    once = true,
    callback = load_markview,
  })

  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    pattern = { vaults_root .. "/**/*.md" },
    callback = load_obsidian,
  })

  runtime.command("Obsidian", load_obsidian, { desc = "Open Obsidian command" })

  vim.keymap.set("n", "<leader>mp", function()
    load_markview()
    vim.cmd("Markview splitToggle")
  end, { desc = "Markdown preview split" })

  vim.keymap.set("n", "<leader>op", function()
    open_vault_in_floating_nvim(vaults_root .. "/personal")
  end, { desc = "Obsidian open personal" })
  vim.keymap.set("n", "<leader>oh", function()
    open_vault_in_floating_nvim(vaults_root .. "/htwk")
  end, { desc = "Obsidian open htwk" })
  vim.keymap.set("n", "<leader>ow", function()
    open_vault_in_floating_nvim(vaults_root .. "/work")
  end, { desc = "Obsidian open work" })
  vim.keymap.set("n", "<leader>on", function()
    load_obsidian()
    vim.cmd("Obsidian new")
  end, { desc = "Obsidian new" })
  vim.keymap.set("n", "<leader>os", function()
    load_obsidian()
    vim.cmd("Obsidian search")
  end, { desc = "Obsidian search" })
  vim.keymap.set("n", "<leader>oq", function()
    load_obsidian()
    vim.cmd("Obsidian quick_switch")
  end, { desc = "Obsidian quick switch" })
  vim.keymap.set("n", "<leader>oo", function()
    snacks.load().picker.select({ "personal", "htwk", "work" }, { prompt = "Select Vault" }, function(vault)
      if not vault then
        return
      end
      open_vault_in_floating_nvim(vaults_root .. "/" .. vault)
    end)
  end, { desc = "Obsidian open vault" })
end

return M
