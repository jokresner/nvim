local M = {}

local function on_attach(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local function nmap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gr", vim.lsp.buf.references, "Goto References")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("gT", vim.lsp.buf.type_definition, "Goto Type Definition")
  nmap("K", vim.lsp.buf.hover, "Hover")
  nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")

  -- Optional: disable semantic tokens per filetype if desired
  if vim.bo[bufnr].filetype == "lua" and client.server_capabilities then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.setup = function()
  -- Built-in defaults for diagnostics
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- Enable builtin LSP completion autotrigger (no external completion manager required)
  vim.opt.completeopt:append({ "menuone", "noselect", "popup" })

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then return end

  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
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
    rust_analyzer = {},
  }

  for name, cfg in pairs(servers) do
    cfg.capabilities = capabilities
    cfg.on_attach = on_attach
    lspconfig[name].setup(cfg)
  end

  -- Turn on LSP-driven completion in buffers on attach
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end
    end,
  })
end

return M


