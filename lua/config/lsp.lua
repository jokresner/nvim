local M = {}

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  }),
}

M.servers = {
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = (function()
          local ok, schemastore = pcall(require, "schemastore")
          return ok and schemastore.json.schemas() or nil
        end)(),
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = (function()
          local ok, schemastore = pcall(require, "schemastore")
          return ok and schemastore.yaml.schemas() or nil
        end)(),
        keyOrdering = false,
      },
    },
  },
  ["harper-ls"] = {
    filetypes = {
      "markdown",
      "gitcommit",
      "text",
    },
    settings = {
      ["harper-ls"] = {
        linters = {
          SpellCheck = true,
          SpelledNumbers = false,
          AnA = true,
          SentenceCapitalization = true,
          UnclosedQuotes = true,
          WrongQuotes = false,
          LongSentences = true,
          RepeatedWords = true,
          Spaces = true,
          Matcher = true,
          CorrectNumberSuffix = true,
        },
      },
    },
    diagnosticSeverity = "hint",
    isolateEnglish = false,
    dialect = "American",
    maxFileLength = 120000,
    ignoredLintsPath = {},
  },
}

M.ensure_installed = {
  "stylua",
  "lua_ls",
  "delve",
  "gopls",
  "golangci-lint",
  "luacheck",
  "codelldb",
  "harper-ls",
  "ast-grep",
}

local function compute_servers_to_install(servers)
  return vim.tbl_filter(function(key)
    local t = servers[key]
    if type(t) == "table" then
      return not t.manual_install
    else
      return t
    end
  end, vim.tbl_keys(servers))
end

function M.setup()
  require("mason-nvim-dap").setup()

  local servers = M.servers
  local servers_to_install = compute_servers_to_install(servers)

  local ensure_installed = vim.deepcopy(M.ensure_installed)
  vim.list_extend(ensure_installed, servers_to_install)

  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }
    end,
  })

  for name, config in pairs(servers) do
    if config == true then
      config = {}
    end
    config.handlers = handlers
    vim.lsp.config(name, config)
  end

  local disable_semantic_tokens = { lua = true }

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

      local settings = servers[client.name]
      if type(settings) ~= "table" then
        settings = {}
      end

      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

      local filetype = vim.bo[bufnr].filetype
      if disable_semantic_tokens[filetype] then
        client.server_capabilities.semanticTokensProvider = nil
      end

      if settings.server_capabilities then
        for k, v in pairs(settings.server_capabilities) do
          if v == vim.NIL then
            v = nil
          end
          client.server_capabilities[k] = v
        end
      end
    end,
  })

  vim.diagnostic.config {
    virtual_text = {
      prefix = "●",
      source = "if_many",
    },
    float = {
      border = "rounded",
      source = "always",
    },
    virtual_lines = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
      numhl = {
        [vim.diagnostic.severity.WARN] = "WarningMsg",
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticHint",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  }
end

return M
