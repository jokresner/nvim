return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
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
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
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
      },
    },
  },
  { "stevearc/dressing.nvim", event = "VeryLazy", opts = { input = { default_prompt = ">" } } },
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("hlslens").setup()
      local map = vim.keymap.set
      local opts = { silent = true }
      map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]], opts)
      map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]], opts)
      map("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
      map("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
    end,
  },
  {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    opts = {
      scope = "line",
      placement = "inline",
      inline_padding_left = 2,
      padding_right = 0,
      max_width = 80,
      show_sign = true,
    },
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      highlight = true,
      separator = " > ",
      depth_limit = 5,
      lsp = {
        auto_attach = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
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
    },
    keys = {
      {
        "<leader>un",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>uN",
        function()
          require("noice").cmd "all"
        end,
        desc = "Show notifications",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "SmiteshP/nvim-navic" },
    opts = function()
      local navic = require "nvim-navic"
      local line_author_group = vim.api.nvim_create_augroup("statusline_line_author", { clear = true })
      local line_author_timer = nil
      local line_author_request = 0
      local lualine_theme = "auto"
      if pcall(require, "lualine.themes.catppuccin") then
        lualine_theme = "catppuccin"
      end
      local function line_author_component()
        return vim.b.line_author or ""
      end
      local function update_line_author(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local file = vim.api.nvim_buf_get_name(bufnr)
        if file == "" then
          vim.b[bufnr].line_author = ""
          vim.b[bufnr].line_author_key = nil
          return
        end

        local git_dir = vim.fs.find(".git", { path = file, upward = true })[1]
        if not git_dir then
          vim.b[bufnr].line_author = ""
          vim.b[bufnr].line_author_key = nil
          return
        end

        local line = vim.api.nvim_win_get_cursor(0)[1]
        local repo_root = vim.fs.dirname(git_dir)
        local relative = vim.fs.relpath(repo_root, file)
        if not relative then
          vim.b[bufnr].line_author = ""
          vim.b[bufnr].line_author_key = nil
          return
        end

        local cache_key = relative .. ":" .. line
        if vim.b[bufnr].line_author_key == cache_key then
          return
        end

        line_author_request = line_author_request + 1
        local request_id = line_author_request

        vim.system({
          "git",
          "blame",
          "--line-porcelain",
          "-L",
          string.format("%d,%d", line, line),
          "--",
          relative,
        }, { cwd = repo_root, text = true }, function(res)
          local author = ""
          if res.code == 0 and res.stdout then
            author = res.stdout:match "\nauthor (.-)\n" or ""
          end

          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) or request_id ~= line_author_request then
              return
            end

            vim.b[bufnr].line_author = author ~= "" and (" " .. author) or ""
            vim.b[bufnr].line_author_key = cache_key
            local ok, lualine = pcall(require, "lualine")
            if ok then
              lualine.refresh()
            end
          end)
        end)
      end
      local function schedule_line_author_update(args)
        local bufnr = args and args.buf or vim.api.nvim_get_current_buf()
        if line_author_timer then
          line_author_timer:stop()
          line_author_timer:close()
        end

        line_author_timer = vim.defer_fn(function()
          update_line_author(bufnr)
          line_author_timer = nil
        end, 120)
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorHold" }, {
        group = line_author_group,
        callback = schedule_line_author_update,
      })
      local function context_mode_component()
        local mode = vim.g.context_mode or "compact"
        if mode == "reading" then
          return "R"
        end
        return "C"
      end
      local function lsp_name()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then
          return ""
        end
        local ignored = {
          ["null-ls"] = true,
          ["conform"] = true,
        }
        local low_priority = {
          ["eslint"] = true,
          ["harper_ls"] = true,
        }

        local primary = nil
        local secondary = nil
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
        if primary then
          return primary
        end
        if secondary then
          return secondary
        end
        return clients[1].name
      end
      local function project_root(bufnr)
        bufnr = bufnr or 0
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == "" then
          return vim.loop.cwd()
        end

        local clients = vim.lsp.get_clients { bufnr = bufnr }
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
        if git_dir then
          return vim.fs.dirname(git_dir)
        end

        return vim.loop.cwd()
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
        if hl.fg then
          out.fg = string.format("#%06x", hl.fg)
        end
        if hl.bg then
          out.bg = string.format("#%06x", hl.bg)
        end
        return out
      end
      local path_color = statusline_hl("Directory", { gui = "bold" })
      path_color.gui = "bold"
      local navic_color = statusline_hl("Comment", {})
      local navic_separator_color = statusline_hl("Comment", {})
      local project_path_component = {
        function()
          local name = vim.api.nvim_buf_get_name(0)
          if name == "" then
            return "[No Name]"
          end

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
      }
      local navic_separator_component = {
        function()
          return " > "
        end,
        cond = function()
          return navic.is_available() and navic.get_location() ~= ""
        end,
        color = navic_separator_color,
        padding = { left = 0, right = 0 },
        separator = "",
      }
      local navic_component = {
        function()
          if navic.is_available() then
            return navic.get_location()
          end
          return ""
        end,
        cond = function()
          return navic.is_available() and navic.get_location() ~= ""
        end,
        color = navic_color,
        padding = { left = 0, right = 1 },
        separator = "",
      }

      return {
        options = {
          theme = lualine_theme,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { project_path_component, navic_separator_component, navic_component },
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
            line_author_component,
            lsp_name,
            "filetype",
            "diagnostics",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
  {
    "nvim-mini/mini.starter",
    event = "VimEnter",
    opts = function()
      local function footer()
        local version = vim.version()
        local lazy_ok, lazy = pcall(require, "lazy")
        local startup_ms = 0

        if vim.g.start_time then
          startup_ms = (vim.uv.hrtime() - vim.g.start_time) / 1000000
        end

        if lazy_ok then
          local stats = lazy.stats()
          return string.format(
            "Neovim v%d.%d.%d | %d/%d Plugins | Startup %.2fms",
            version.major,
            version.minor,
            version.patch,
            stats.loaded,
            stats.count,
            startup_ms
          )
        end

        return string.format(
          "Neovim v%d.%d.%d | Startup %.2fms",
          version.major,
          version.minor,
          version.patch,
          startup_ms
        )
      end

      return {
        footer = footer,
        header = table.concat({
          [[     __        __                                               ]],
          [[    |__| ____ |  | _________   ____   ______ ____   ___________ ]],
          [[    |  |/  _ \|  |/ /\_  __ \_/ __ \ /  ___//    \_/ __ \_  __ \]],
          [[    |  (  <_> )    <  |  | \/\  ___/ \___ \|   |  \  ___/|  | \/]],
          [[/\__|  |\____/|__|_ \ |__|    \___  >____  >___|  /\___  >__|   ]],
          [[\______|           \/             \/     \/     \/     \/       ]],
        }, "\n"),
        items = {
          {
            action = function()
              require("snacks").picker.smart()
            end,
            name = "F: Find File",
            section = "File",
          },
          {
            action = function()
              require("snacks").picker.recent()
            end,
            name = "R: Recent Files",
            section = "File",
          },
          {
            action = function()
              require("snacks").picker.grep_word()
            end,
            name = "W: Find Word",
            section = "Search",
          },
          {
            action = function()
              require("snacks").picker.grep()
            end,
            name = "G: Grep",
            section = "Search",
          },
          { action = "Lazy", name = "L: Lazy", section = "Plugins" },
          {
            action = function()
              require("snacks").picker.projects()
            end,
            name = "P: Projects",
            section = "File",
          },
          {
            action = function()
              vim.cmd "qa"
            end,
            name = "Q: Quit",
            section = "Exit",
          },
        },
        evaluate_single = true,
        content_hooks = nil,
      }
    end,
  },
  {
    "nvim-mini/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = { symbol = "|", options = { try_as_border = true } },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "lazy", "mason", "snacks_picker" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "VeryLazy",
    opts = function()
      local hi = require "mini.hipatterns"
      return { highlighters = { hex_color = hi.gen_highlighter.hex_color() } }
    end,
  },
  {
    "nvim-mini/mini.tabline",
    version = false,
    event = "VeryLazy",
    opts = {
      tabpage_section = "right",
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    opts = function()
      local b = require "statuscol.builtin"
      return {
        segments = {
          { text = { b.foldfunc }, click = "v:lua.ScFa" },
          { text = { " %s" }, click = "v:lua.ScSa" },
          { text = { b.lnumfunc, " " }, click = "v:lua.ScLa" },
        },
      }
    end,
  },
  { "jghauser/fold-cycle.nvim", event = "VeryLazy", opts = {} },
  { "OXY2DEV/helpview.nvim", ft = "help" },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  { "oribarilan/lensline.nvim", event = "LspAttach", opts = {} },
  {
    "gisketch/triforce.nvim",
    event = "VeryLazy",
    dependencies = { "nvzone/volt" },
    opts = { keymap = { show_profile = "<leader>up" } },
  },
  {
    "TheNoeTrevino/haunt.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>ha",
        function()
          require("haunt.api").annotate()
        end,
        desc = "Haunt annotate",
      },
      {
        "<leader>ht",
        function()
          require("haunt.api").toggle_annotation()
        end,
        desc = "Haunt toggle",
      },
      {
        "<leader>hn",
        function()
          require("haunt.api").next()
        end,
        desc = "Haunt next",
      },
      {
        "<leader>hp",
        function()
          require("haunt.api").prev()
        end,
        desc = "Haunt prev",
      },
      {
        "<leader>hl",
        function()
          require("haunt.picker").show()
        end,
        desc = "Haunt list",
      },
    },
  },
}
