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
    local schemastore = require "schemastore"
    return {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
  yamlls = function()
    local schemastore = require "schemastore"
    return {
      settings = {
        yaml = {
          schemas = schemastore.yaml.schemas(),
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

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

      -- Lazy check for semantic tokens
      local filetype = vim.bo[bufnr].filetype
      if disable_semantic_tokens[filetype] then
        client.server_capabilities.semanticTokensProvider = nil
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
