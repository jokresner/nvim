local M = {}

local border = "rounded"

M.servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        hint = { enable = true },
      },
    },
  },
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
  vtsls = {},
  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
      },
    },
  },
  harper_ls = {
    filetypes = { "markdown", "gitcommit", "text" },
    settings = {
      ["harper-ls"] = {
        linters = {
          SpellCheck = true,
          SentenceCapitalization = true,
          LongSentences = true,
          RepeatedWords = true,
        },
      },
    },
  },
}

M.tools = {
  "stylua",
  "lua_ls",
  "delve",
  "codelldb",
  "gopls",
  "golangci-lint",
  "luacheck",
  "harper-ls",
  "ast-grep",
  "vtsls",
  "jsonls",
  "yamlls",
}

function M.setup()
  local has_blink, blink = pcall(require, "blink.cmp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if has_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = border, source = "always" },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

  local disable_semantic_tokens = {
    lua = true,
  }

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and disable_semantic_tokens[vim.bo[event.buf].filetype] then
        client.server_capabilities.semanticTokensProvider = nil
      end

      local ok_navic, navic = pcall(require, "nvim-navic")
      if ok_navic and client and client.server_capabilities.documentSymbolProvider then
        pcall(navic.attach, client, event.buf)
      end

      local map = vim.keymap.set
      local opts = { buffer = event.buf, silent = true }
      local ok_snacks, snacks = pcall(require, "snacks")

      map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
      map("n", "gd", function()
        if ok_snacks then
          snacks.picker.lsp_definitions()
          return
        end
        vim.lsp.buf.definition()
      end, vim.tbl_extend("force", opts, { desc = "Go definition" }))
      map("n", "gD", function()
        if ok_snacks then
          snacks.picker.lsp_declarations()
          return
        end
        vim.lsp.buf.declaration()
      end, vim.tbl_extend("force", opts, { desc = "Go declaration" }))
      map("n", "gI", function()
        if ok_snacks then
          snacks.picker.lsp_implementations()
          return
        end
        vim.lsp.buf.implementation()
      end, vim.tbl_extend("force", opts, { desc = "Go implementation" }))
      map("n", "gR", function()
        if ok_snacks then
          snacks.picker.lsp_references()
          return
        end
        vim.lsp.buf.references()
      end, vim.tbl_extend("force", opts, { desc = "Go references" }))
      map("n", "gr", function()
        if ok_snacks then
          snacks.picker.lsp_references()
          return
        end
        vim.lsp.buf.references()
      end, vim.tbl_extend("force", opts, { desc = "Go references" }))
      map("n", "gy", function()
        if ok_snacks then
          snacks.picker.lsp_type_definitions()
          return
        end
        vim.lsp.buf.type_definition()
      end, vim.tbl_extend("force", opts, { desc = "Go type definition" }))
      map("n", "gai", function()
        if ok_snacks then
          snacks.picker.lsp_incoming_calls()
        end
      end, vim.tbl_extend("force", opts, { desc = "Incoming calls" }))
      map("n", "gao", function()
        if ok_snacks then
          snacks.picker.lsp_outgoing_calls()
        end
      end, vim.tbl_extend("force", opts, { desc = "Outgoing calls" }))

      map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
      map("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Code rename" }))
      map("n", "<leader>cf", "<cmd>Format<cr>", vim.tbl_extend("force", opts, { desc = "Code format" }))
      map("n", "<leader>cs", vim.lsp.buf.document_symbol, vim.tbl_extend("force", opts, { desc = "Code symbols" }))

      map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
      map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
      map("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
    end,
  })

  require("mason-lspconfig").setup({
    automatic_installation = false,
    handlers = {
      function(server)
        local cfg = vim.deepcopy(M.servers[server] or {})

        if server == "jsonls" or server == "yamlls" then
          local ok_lazy, lazy = pcall(require, "lazy")
          if ok_lazy then
            pcall(lazy.load, { plugins = { "SchemaStore.nvim" } })
          end
          local ok_schema, schemastore = pcall(require, "schemastore")
          if ok_schema then
            if server == "jsonls" then
              cfg.settings = cfg.settings or {}
              cfg.settings.json = cfg.settings.json or {}
              cfg.settings.json.schemas = schemastore.json.schemas()
            else
              cfg.settings = cfg.settings or {}
              cfg.settings.yaml = cfg.settings.yaml or {}
              cfg.settings.yaml.schemas = schemastore.yaml.schemas()
            end
          end
        end

        cfg.capabilities = capabilities
        require("lspconfig")[server].setup(cfg)
      end,
      ["rust_analyzer"] = function() end,
    },
  })
end

return M
