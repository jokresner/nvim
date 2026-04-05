local runtime = require("config.pack_runtime")
local snacks = require("config.snacks")

local M = {}

function M.setup()
  local load_catppuccin = runtime.once(function()
    runtime.load("catppuccin")
    require("catppuccin").setup({
      default_integrations = false,
      integrations = {
        blink_cmp = { style = "bordered" },
        flash = true,
        gitsigns = true,
        markview = true,
        mini = { enabled = true, indentscope_color = "mauve" },
        neogit = true,
        neotest = true,
        noice = true,
        notify = true,
        dap = true,
        dap_ui = true,
        ufo = true,
        overseer = true,
        which_key = true,
      },
      background = { light = "latte", dark = "mocha" },
      transparent_background = true,
    })
    vim.cmd.colorscheme("catppuccin")
  end)

  local load_which_key = runtime.once(function()
    runtime.load("which-key")
    require("which-key").setup({
      preset = "helix",
      delay = 300,
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunks/Haunt" },
        { "<leader>j", group = "Jira" },
        { "<leader>k", group = "Knowledge" },
        { "<leader>m", group = "Markdown" },
        { "<leader>o", group = "Obsidian" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>r", group = "Refactor" },
        { "<leader>R", group = "REST" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Test" },
        { "<leader>u", group = "UI/Toggle" },
        { "<leader>ut", group = "Context mode" },
        { "<leader>v", group = "Visits" },
        { "<leader>x", group = "Diagnostics/Tasks" },
        { "<leader>z", group = "Zellij" },
      },
    })
  end)

  local load_dressing = runtime.once(function()
    runtime.load("dressing")
    require("dressing").setup({ input = { default_prompt = ">" } })
  end)

  local load_hlslens = runtime.once(function()
    runtime.load("hlslens")
    require("hlslens").setup()
    local map = vim.keymap.set
    local opts = { silent = true }
    map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]], opts)
    map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]], opts)
    map("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
    map("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
  end)

  local load_diagflow = runtime.once(function()
    runtime.load("diagflow")
    require("diagflow").setup({ scope = "line", padding_right = 2 })
  end)

  local load_navic = runtime.once(function()
    runtime.load("nvim-navic")
    require("nvim-navic").setup({
      highlight = true,
      separator = " > ",
      depth_limit = 5,
      lsp = { auto_attach = false },
    })
  end)

  local load_noice = runtime.once(function()
    runtime.load_many({ "nui", "notify", "noice" })
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    })
  end)

  local load_lualine = runtime.once(function()
    load_navic()
    runtime.load("lualine")
    local navic = require("nvim-navic")
    local lualine_theme = pcall(require, "lualine.themes.catppuccin") and "catppuccin" or "auto"
    local function context_mode_component()
      return (vim.g.context_mode or "compact") == "reading" and "R" or "C"
    end
    local function lsp_name()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return ""
      end
      local ignored = { copilot = true, ["null-ls"] = true, conform = true }
      local low_priority = { eslint = true, harper_ls = true }
      local primary, secondary
      for _, client in ipairs(clients) do
        if not ignored[client.name] then
          if low_priority[client.name] then
            secondary = secondary or client.name
          else
            primary = primary or client.name
          end
        end
      end
      if primary and secondary and secondary ~= primary then
        return primary .. "+" .. secondary
      end
      return primary or secondary or clients[1].name
    end
    local function project_root(bufnr)
      bufnr = bufnr or 0
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return vim.loop.cwd()
      end
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, client in ipairs(clients) do
        local workspace_folders = client.config.workspace_folders
        if workspace_folders then
          for _, workspace in ipairs(workspace_folders) do
            local root = vim.uri_to_fname(workspace.uri)
            if name:find(root, 1, true) == 1 then
              return root
            end
          end
        end
        local root = client.config.root_dir
        if root and name:find(root, 1, true) == 1 then
          return root
        end
      end
      local git_dir = vim.fs.find(".git", { path = name, upward = true })[1]
      return git_dir and vim.fs.dirname(git_dir) or vim.loop.cwd()
    end
    local function truncate_path(path, max_width)
      if vim.fn.strdisplaywidth(path) <= max_width then
        return path
      end
      local parts = vim.split(path, "/", { plain = true })
      if #parts <= 1 then
        return vim.fn.pathshorten(path)
      end
      local tail = table.remove(parts)
      local shortened = vim.fn.pathshorten(table.concat(parts, "/"))
      local candidate = shortened ~= "" and (shortened .. "/" .. tail) or tail
      if vim.fn.strdisplaywidth(candidate) <= max_width then
        return candidate
      end
      local tail_width = vim.fn.strdisplaywidth(tail)
      if tail_width + 2 >= max_width then
        return "…" .. vim.fn.strcharpart(tail, math.max(0, vim.fn.strchars(tail) - (max_width - 1)))
      end
      local keep = math.max(1, max_width - tail_width - 3)
      return "…" .. vim.fn.strcharpart(candidate, vim.fn.strchars(candidate) - (tail_width + keep))
    end
    local function statusline_hl(name, fallback)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if not ok or not hl or vim.tbl_isempty(hl) then
        return fallback or {}
      end
      local out = vim.deepcopy(fallback or {})
      if hl.fg then out.fg = string.format("#%06x", hl.fg) end
      if hl.bg then out.bg = string.format("#%06x", hl.bg) end
      return out
    end
    local path_color = statusline_hl("Directory", { gui = "bold" })
    path_color.gui = "bold"
    local navic_color = statusline_hl("Comment", {})
    local navic_separator_color = statusline_hl("Comment", {})
    require("lualine").setup({
      options = { theme = lualine_theme, globalstatus = true },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            function()
              local name = vim.api.nvim_buf_get_name(0)
              if name == "" then return "[No Name]" end
              local root = project_root(0)
              local relative = vim.fs.relpath(root, name)
              if relative and relative ~= "." then
                return truncate_path(relative, math.max(20, math.floor(vim.o.columns * 0.35)))
              end
              return vim.fn.fnamemodify(name, ":t")
            end,
            color = path_color,
            padding = { left = 1, right = 0 },
            separator = "",
          },
          {
            function() return " > " end,
            cond = function() return navic.is_available() and navic.get_location() ~= "" end,
            color = navic_separator_color,
            padding = { left = 0, right = 0 },
            separator = "",
          },
          {
            function() return navic.is_available() and navic.get_location() or "" end,
            cond = function() return navic.is_available() and navic.get_location() ~= "" end,
            color = navic_color,
            padding = { left = 0, right = 1 },
            separator = "",
          },
        },
        lualine_x = {
          {
            context_mode_component,
            color = function()
              if (vim.g.context_mode or "compact") == "reading" then
                return { fg = "#f9e2af", gui = "bold" }
              end
              return { fg = "#a6e3a1", gui = "bold" }
            end,
          },
          lsp_name,
          "filetype",
          "diagnostics",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end)

  local load_starter = runtime.once(function()
    runtime.load("mini-starter")
    local starter = require("mini.starter")
    starter.setup({
      footer = function()
        local version = vim.version()
        local startup_ms = vim.g.start_time and ((vim.uv.hrtime() - vim.g.start_time) / 1000000) or 0
        local stats = runtime.stats()
        return string.format(
          "Neovim v%d.%d.%d | Pack %d/%d | Pack %.2fms | Startup %.2fms",
          version.major,
          version.minor,
          version.patch,
          stats.startup_loaded,
          stats.count,
          stats.startup_ms,
          startup_ms
        )
      end,
      header = table.concat({
        [[     __        __                                               ]],
        [[    |__| ____ |  | _________   ____   ______ ____   ___________ ]],
        [[    |  |/  _ \|  |/ /\_  __ \_/ __ \ /  ___//    \_/ __ \_  __ \]],
        [[    |  (  <_> )    <  |  | \/\  ___/ \___ \|   |  \  ___/|  | \/]],
        [[/\__|  |\____/|__|_ \ |__|    \___  >____  >___|  /\___  >__|   ]],
        [[\______|           \/             \/     \/     \/     \/       ]],
      }, "\n"),
      items = {
        { action = function() snacks.picker("smart") end, name = "F: Find File", section = "File" },
        { action = function() snacks.picker("recent") end, name = "R: Recent Files", section = "File" },
        { action = function() snacks.picker("grep_word") end, name = "W: Find Word", section = "Search" },
        { action = function() snacks.picker("grep") end, name = "G: Grep", section = "Search" },
        { action = function() vim.cmd("checkhealth vim.pack") end, name = "H: Pack Health", section = "Plugins" },
        { action = function() snacks.picker("projects") end, name = "P: Projects", section = "File" },
        { action = function() vim.cmd("qa") end, name = "Q: Quit", section = "Exit" },
      },
      evaluate_single = true,
      content_hooks = nil,
    })

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local should_open = vim.fn.argc() == 0
      and vim.api.nvim_buf_get_name(0) == ""
      and vim.bo.buftype == ""
      and not vim.bo.modified
      and #lines == 1
      and lines[1] == ""

    if should_open then
      starter.open()
    end
  end)

  local load_indentscope = runtime.once(function()
    runtime.load("mini-indentscope")
    require("mini.indentscope").setup({ symbol = "|", options = { try_as_border = true } })
  end)

  local load_hipatterns = runtime.once(function()
    runtime.load("mini-hipatterns")
    local hi = require("mini.hipatterns")
    hi.setup({ highlighters = { hex_color = hi.gen_highlighter.hex_color() } })
  end)

  local load_tabline = runtime.once(function()
    runtime.load("mini-tabline")
    require("mini.tabline").setup({ tabpage_section = "right" })
  end)

  local load_statuscol = runtime.once(function()
    runtime.load("statuscol")
    local b = require("statuscol.builtin")
    require("statuscol").setup({
      segments = {
        { text = { b.foldfunc }, click = "v:lua.ScFa" },
        { text = { " %s" }, click = "v:lua.ScSa" },
        { text = { b.lnumfunc, " " }, click = "v:lua.ScLa" },
      },
    })
  end)

  local load_fold_cycle = runtime.once(function()
    runtime.load("fold-cycle")
    require("fold-cycle").setup({})
  end)

  local load_helpview = runtime.once(function()
    runtime.load("helpview")
  end)

  local load_ufo = runtime.once(function()
    runtime.load_many({ "promise-async", "ufo" })
    require("ufo").setup({ provider_selector = function() return { "treesitter", "indent" } end })
  end)

  local load_lensline = runtime.once(function()
    runtime.load("lensline")
    require("lensline").setup({})
  end)

  local load_triforce = runtime.once(function()
    runtime.load_many({ "volt", "triforce" })
    require("triforce").setup({ keymap = { show_profile = "<leader>up" } })
  end)

  local load_haunt = runtime.once(function()
    runtime.load("haunt")
    require("haunt").setup({})
  end)

  load_catppuccin()
  runtime.defer(load_which_key)
  runtime.defer(load_dressing)
  runtime.defer(load_hlslens)
  runtime.defer(load_noice)
  runtime.defer(load_lualine)
  runtime.defer(load_starter)
  runtime.defer(load_hipatterns)
  runtime.defer(load_tabline)
  runtime.defer(load_statuscol)
  runtime.defer(load_fold_cycle)
  runtime.defer(load_triforce)
  runtime.defer(load_haunt)

  vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
      load_diagflow()
      load_lensline()
    end,
  })
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = load_indentscope,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "mason", "snacks_picker" },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    once = true,
    callback = load_helpview,
  })
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = load_ufo,
  })

  vim.keymap.set("n", "<leader>un", function()
    load_noice()
    require("noice").cmd("dismiss")
  end, { desc = "Dismiss notifications" })
  vim.keymap.set("n", "<leader>uN", function()
    load_noice()
    require("noice").cmd("all")
  end, { desc = "Show notifications" })
  vim.keymap.set("n", "<leader>ha", function()
    load_haunt()
    require("haunt.api").annotate()
  end, { desc = "Haunt annotate" })
  vim.keymap.set("n", "<leader>ht", function()
    load_haunt()
    require("haunt.api").toggle_annotation()
  end, { desc = "Haunt toggle" })
  vim.keymap.set("n", "<leader>hn", function()
    load_haunt()
    require("haunt.api").next()
  end, { desc = "Haunt next" })
  vim.keymap.set("n", "<leader>hp", function()
    load_haunt()
    require("haunt.api").prev()
  end, { desc = "Haunt prev" })
  vim.keymap.set("n", "<leader>hl", function()
    load_haunt()
    require("haunt.picker").show()
  end, { desc = "Haunt list" })
end

return M
