# Domain Glossary

- **Plugin File**: A `lua/plugins/*.lua` file returning one or more lazy.nvim plugin specs for a specific domain (e.g. Git, Testing, LSP, Go). It owns all plugin declarations, `keys`, and `opts` for that domain.

- **LSP Engine**: `lua/core/lsp_engine.lua` — configures and enables servers from server records, applies the default attach keymaps, then each record's own `keys`. Mason installation is not its job; `core.lang` puts server names in the single install list.

- **Language**: a plain data table in `lua/langs/<name>.lua` describing everything one language needs (parsers, mason tools, LSP server records, formatters, linters, test and debug adapters, buffer options, language-only plugins). It is the only place a language is declared.

- **Language Module**: `lua/core/lang.lua` — merges all Languages into lazy.nvim specs, the one mason install list, the LSP server list and the parser list. Owns the lazy.nvim merge rules, and `check` reports drift (duplicate installs, formatters/linters nobody installs, filetypes without a parser).

- **Tooling Plugin File**: `lua/plugins/tooling.lua` — owns the base `conform.nvim` and `nvim-lint` specs and the lint autocmd. Languages add their formatters and linters through the Language Module.

- **Native Treesitter Plugin File**: `lua/plugins/treesitter.lua` — owns parser installation and the native `vim.treesitter.start()` autocmd inside the nvim-treesitter `config` function. The plugin downloads parsers only; highlighting is native.

- **Global Keymaps**: `lua/config/keymaps.lua` — non-plugin-dependent keymaps (buffer nav, clipboard, scroll, escape) set eagerly at startup before lazy loads.

- **AI Terminal**: the Snacks terminals running the `hx` and `pi` agents, opened with `<leader>aa` / `<leader>ap`. `<leader>af` and `<leader>al` send the current file or line to the last opened agent.
