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

-- Server configs are factories so heavy deps (SchemaStore) are only required when needed.
local server_factories = {
  gopls = function()
    return {
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
    }
  end,
  jsonls = function()
    return {
      settings = {
        json = {
          validate = { enable = true },
        },
      },
    }
  end,
  yamlls = function()
    return {
      settings = {
        yaml = {
          keyOrdering = false,
        },
      },
    }
  end,
  ["harper-ls"] = function()
    return {
      filetypes = { "markdown", "gitcommit", "text" },
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
    }
  end,
}

function M.get_server_config(server_name)
  local f = server_factories[server_name]
  return f and f() or {}
end

function M.setup()
  require("mason-nvim-dap").setup()

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Ensure completion capabilities if blink is available (it should be loaded before LSP in this config).
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  -- Set up mason-lspconfig to automatically set up installed servers
  require("mason-lspconfig").setup {
    automatic_installation = false, -- handled by ensure.nvim
    handlers = {
      function(server_name)
        -- Only load the specific config for the server being started
        local server_config = M.get_server_config(server_name)
        if server_config == true then
          server_config = {}
        end
        server_config.handlers = handlers
        server_config.capabilities = capabilities
        require("lspconfig")[server_name].setup(server_config)
      end,
    },
  }

  local disable_semantic_tokens = { lua = true }
  local schemastore_cache = { json = nil, yaml = nil }

  local function load_schemastore()
    local ok_lazy, lazy = pcall(require, "lazy")
    if ok_lazy then
      pcall(lazy.load, { plugins = { "SchemaStore.nvim" } })
    end
    local ok, schemastore = pcall(require, "schemastore")
    if not ok then
      return nil
    end
    return schemastore
  end

  local function maybe_apply_schemas(client)
    if client == nil or client.name == nil then
      return
    end
    if client._user_schemastore_applied then
      return
    end

    if client.name ~= "jsonls" and client.name ~= "yamlls" then
      return
    end

    local schemastore = load_schemastore()
    if not schemastore then
      return
    end

    client.config.settings = client.config.settings or {}

    if client.name == "jsonls" then
      if schemastore_cache.json == nil then
        schemastore_cache.json = schemastore.json.schemas()
      end
      client.config.settings.json = client.config.settings.json or {}
      client.config.settings.json.schemas = schemastore_cache.json
    elseif client.name == "yamlls" then
      if schemastore_cache.yaml == nil then
        schemastore_cache.yaml = schemastore.yaml.schemas()
      end
      client.config.settings.yaml = client.config.settings.yaml or {}
      client.config.settings.yaml.schemas = schemastore_cache.yaml
    end

    client._user_schemastore_applied = true
    pcall(client.notify, client, "workspace/didChangeConfiguration", { settings = client.config.settings })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

      -- Lazy check for semantic tokens
      local filetype = vim.bo[bufnr].filetype
      if disable_semantic_tokens[filetype] then
        client.server_capabilities.semanticTokensProvider = nil
      end

      -- Apply SchemaStore-backed schemas lazily (only when the server actually attaches).
      maybe_apply_schemas(client)
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
