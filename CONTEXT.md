# Domain Glossary

- **Plugin File**: A `lua/plugins/*.lua` file returning one or more lazy.nvim plugin specs for a specific domain (e.g. Git, Testing, LSP, Go). It owns all plugin declarations, `keys`, and `opts` for that domain.

- **LSP Engine**: `lua/core/lsp_engine.lua` — the single module responsible for wiring language servers, Mason, mason-lspconfig, and Blink capabilities together. Called from `lua/plugins/lsp.lua` with a flat server table. Language servers are declared there centrally.

- **Tooling Plugin File**: `lua/plugins/tooling.lua` — owns the base `conform.nvim` and `nvim-lint` specs including shared formatters (lua, json, yaml, markdown) and the lint autocmd. Language plugin files inject additional formatters and linters via `optional = true` opts merging.

- **Language Plugin File**: `lua/plugins/lang_<name>.lua` — injects language-specific adapters into the shared plugin specs (conform, nvim-lint, neotest, nvim-dap) via `optional = true`. Does not declare LSP — those go in `lua/plugins/lsp.lua`.

- **Native Treesitter Plugin File**: `lua/plugins/treesitter.lua` — owns parser installation and the native `vim.treesitter.start()` autocmd inside the nvim-treesitter `config` function. The plugin downloads parsers only; highlighting is native.

- **Global Keymaps**: `lua/config/keymaps.lua` — non-plugin-dependent keymaps (buffer nav, clipboard, scroll, escape) set eagerly at startup before lazy loads.

- **AI Chat Plugin File**: `lua/plugins/ai_chat.lua` — owns in-editor AI CLI chat through Sidekick. Keeps AI keymaps and CLI window behaviour self-contained without interfering with completion or `<Tab>`.
