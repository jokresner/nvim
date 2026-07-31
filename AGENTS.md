# AI Agent Instructions for this Codebase

Welcome, fellow agent. This is a flat, minimal Neovim configuration built on lazy.nvim's native plugin spec format. Before you write any code or suggest any changes, read these architectural rules.

## 1. Architectural Pattern: Flat Plugin Specs

`lua/plugins/` contains one file per domain. Each file returns a lazy.nvim plugin spec (or a list of specs). lazy.nvim scans the directory automatically — no registry, no boot list.

- **Plugin files:** `lua/plugins/*.lua` — one per domain (e.g. `git.lua`, `lang_go.lua`, `testing.lua`)
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

1. Create `lua/plugins/lang_<name>.lua` with `optional = true` injections into conform/lint/neotest/dap.
2. Add the LSP server config to the `lsps` table in `lua/plugins/lsp.lua`.

```lua
-- lua/plugins/lang_example.lua
return {
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.example = { "examplefmt" }
        end,
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "author/neotest-example" },
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, require("neotest-example"))
        end,
    },
}
```

## 4. Strict Codebase Rules

1. **QWERTZ Layout Constraints:** The user operates on a German QWERTZ keyboard. The bracket keys `[` and `]` are painful to type (requiring `AltGr+8/9`). **Never** add or recommend keymaps relying on `[` or `]`. (e.g., Use `<leader>n`/`<leader>N` for diagnostics, or `<leader>h`/`<leader>H` for git hunks).
2. **Native Treesitter:** Do not enable `highlight = { enable = true }` in `nvim-treesitter`. This config uses a native `vim.treesitter.start()` autocmd inside `lua/plugins/treesitter.lua`'s config function. The plugin is strictly for downloading parsers.
3. **Spec Merging:** To add formatting or linting for a new language, use `optional = true` in the language's plugin file and mutate the `opts` table. Do not modify `tooling.lua` directly.
4. **No Redundant Plugins:** Before installing a new tool, check if the core stack supports it:
   * Do not install `telescope.nvim` / `fzf-lua` → Use `snacks.picker`.
   * Do not install `nvim-tree` / `neo-tree` → Use `yazi.nvim` + `snacks.picker`.
   * Do not install `nvim-notify` / `dashboard-nvim` → Use `snacks.nvim`.
   * Do not install `nvim-cmp` → Use `blink.cmp`.
