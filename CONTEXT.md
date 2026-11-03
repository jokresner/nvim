# Domain Glossary

- **Plugin File**: A `lua/plugins/*.lua` file returning one or more lazy.nvim plugin specs for a specific domain (e.g. Git, Testing, LSP, Go). It owns all plugin declarations, `keys`, and `opts` for that domain.

- **LSP Engine**: `lua/core/lsp_engine.lua` — configures and enables servers from server records, applies the default attach keymaps, then each record's own `keys`. Mason installation is not its job; `core.lang` puts server names in the single install list.

- **Language**: a plain data table in `lua/langs/<name>.lua` describing everything one language needs (parsers, mason tools, LSP server records, formatters, linters, test and debug adapters, buffer options, language-only plugins). It is the only place a language is declared.

- **Language Module**: `lua/core/lang.lua` — merges all Languages into lazy.nvim specs, the one mason install list, the LSP server list and the parser list. Owns the lazy.nvim merge rules, and `check` reports drift (duplicate installs, formatters/linters nobody installs, filetypes without a parser).

- **Tooling Plugin File**: `lua/plugins/tooling.lua` — owns the base `conform.nvim` and `nvim-lint` specs and the lint autocmd. Languages add their formatters and linters through the Language Module.

- **Native Treesitter Plugin File**: `lua/plugins/treesitter.lua` — owns parser installation and the native `vim.treesitter.start()` autocmd inside the nvim-treesitter `config` function. The plugin downloads parsers only; highlighting is native.

- **Global Keymaps**: `lua/config/keymaps.lua` — non-plugin-dependent keymaps (buffer nav, clipboard, scroll, escape) set eagerly at startup before lazy loads.

- **AI Terminal**: `lua/core/ai_terminal.lua` — the Snacks terminals running the agent CLIs (`hx`, `pi`). The agent list lives at the top of `lua/plugins/ui.lua`; keymaps (`<leader>a<key>`, `<leader>af`, `<leader>al`) and the edgy views are generated from it. Also owns the one file reference format (`reference`), shared with `<leader>fl`.

- **UI State**: `lua/core/ui_state.lua` — persisted UI toggles (`<leader>u…`) in `stdpath("state")/ui_toggles.json`, and the only owner of the diagnostic defaults, so a saved toggle is never overridden by LSP setup.

- **Theme**: `lua/core/theme.lua` — owns the external theme file (`~/.local/state/theme/current.json`, wins when present) and the cache (`stdpath("state")/theme_cache.json`: background + colorscheme, written on every `ColorScheme` event, so the colorscheme picker is remembered).

- **Tests**: `tests/test_*.lua`, run with `nvim --headless -u NONE -l tests/run.lua`. They load only `lua/core` and `lua/langs`, never plugins.
