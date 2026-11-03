# AI Agent Instructions for this Codebase

Welcome, fellow agent. This is a flat, minimal Neovim configuration built on lazy.nvim's native plugin spec format. Before you write any code or suggest any changes, read these architectural rules.

## 0. Core Philosophy: Snappy IDE

This configuration strives to provide a **full-fledged IDE feel** without sacrificing a **snappy, instant startup**. To achieve this:

1. **Consolidate:** Prefer multi-utility plugins (like `snacks.nvim`) and fast native alternatives (`blink.cmp`, `fff.nvim`) over bloated legacy ecosystems.
2. **Lazy-Load Everything:** Never block the startup UI. Every UI or tooling plugin must use `event = "VeryLazy"`, `ft`, `cmd`, or `keys` triggers unless it absolutely must run at boot.

## 1. Architectural Pattern: Flat Plugin Specs

`lua/plugins/` contains one file per domain. Each file returns a lazy.nvim plugin spec (or a list of specs). lazy.nvim scans the directory automatically — no registry, no boot list.

- **Plugin files:** `lua/plugins/*.lua` — one per domain (e.g. `git.lua`, `testing.lua`). Languages are the exception: they are data in `lua/langs/*.lua`, merged by `lua/core/lang.lua` through `lua/plugins/lang.lua`.
- **LSP engine:** `lua/core/lsp_engine.lua` — private helper wiring mason → mason-lspconfig → blink capabilities. Called only from `lua/plugins/lsp.lua`.
- **Global keymaps:** `lua/config/keymaps.lua` — non-plugin-dependent keymaps set at startup.
- **Options/autocmds:** `lua/config/options.lua` and `lua/config/autocmds.lua` — loaded before lazy.

## 2. How to Add a Plugin

Drop a new file in `lua/plugins/` returning a valid lazy.nvim spec. lazy picks it up automatically.

```lua
-- lua/plugins/example.lua
return {
    {
        "author/plugin.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>x", function() require("plugin").do_thing() end, desc = "Do thing" },
        },
        opts = { setting = true },
    },
}
```

## 3. How to Add a Language

Create one file, `lua/langs/<name>.lua`, returning a plain data table. `lua/core/lang.lua` merges every language into lazy.nvim specs, one mason install list, the LSP server list and the treesitter parser list. Never write `opts.x = opts.x or {}` merge code; the module owns that.

```lua
-- lua/langs/example.lua  (every field is optional)
return {
    ft = { "example" },
    parsers = { "example" },
    tools = { "examplefmt" },            -- mason packages
    external = { "examplec" },           -- formatter/linter ids installed outside mason (nix, toolchain)
    servers = { { server = "example_ls", config = {} } },  -- see core/lsp_engine.lua for the record fields
    formatters_by_ft = { example = { "examplefmt" } },
    linters_by_ft = { example = { "examplelint" } },
    test = { plugin = "author/neotest-example", adapter = function() return require("neotest-example") end },
    dap = { setup = function(dap) dap.adapters.example = {} end },
    options = { tabstop = 2 },           -- buffer options on FileType
    plugins = {},                        -- extra lazy specs only this language needs
}
```

Run `nvim --headless -u NONE -l tests/run.lua`. It fails if two languages install the same tool, a formatter/linter has no installer or `external` entry, or a filetype has no parser.

Tests live in `tests/test_*.lua` (mini.test) and load only `lua/core` and `lua/langs`, never plugins. New logic goes into `lua/core/<name>.lua` with its dependencies passed in so it can be tested the same way.

## 4. Strict Codebase Rules

1. **QWERTZ Layout Constraints:** The user operates on a German QWERTZ keyboard. The bracket keys `[` and `]` are painful to type (requiring `AltGr+8/9`). **Never** add or recommend keymaps relying on `[` or `]`. (e.g., Use `<leader>n`/`<leader>N` for diagnostics, or `<leader>h`/`<leader>H` for git hunks).
2. **Native Treesitter:** Do not enable `highlight = { enable = true }` in `nvim-treesitter`. This config uses a native `vim.treesitter.start()` autocmd inside `lua/plugins/treesitter.lua`'s config function. The plugin is strictly for downloading parsers.
3. **Spec Merging:** To add formatting, linting, tests or debugging for a language, add it to that language's file in `lua/langs/`. Do not modify `tooling.lua` or write `optional = true` specs by hand.
4. **No Redundant Plugins:** Before installing a new tool, check if the core stack supports it:
   - Do not install `telescope.nvim` / `fzf-lua` → Use `snacks.picker`.
   - Do not install `nvim-tree` / `neo-tree` → Use `yazi.nvim` + `snacks.picker`.
   - Do not install `nvim-notify` / `dashboard-nvim` → Use `snacks.nvim`.
   - Do not install `nvim-cmp` → Use `blink.cmp`.
