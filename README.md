### Neovim Config

#### Bootstrap

1) Install prerequisites (macOS/Homebrew):

```bash
brew install neovim ripgrep fd lazygit yazi pngpaste node pnpm go rust zellij git jq glow
```

2) Optional: isolate this config (recommended for testing):

```bash
export NVIM_APPNAME=nvim
```

3) First-time setup:

```bash
nvim --headless "+Lazy! sync" +qa
```

Open Neovim once normally to finish any post-install steps. If tools aren’t installed yet, run `:Mason` and/or `:Lazy sync`.

Dependencies overview:
- ripgrep (rg): grep pickers
- fd: fast file search
- lazygit: Git TUI integration
- yazi: terminal file manager used by `yazi.nvim`
- pngpaste (macOS): clipboard image support for `img-clip.nvim`
- node + pnpm: builds `mcphub.nvim` and supports some LSPs
- go, rust: language toolchains (DAP/LSP/dev)
- zellij: for `zellij` integration
- glow: for markdown preview

#### Plugin lockfile (lazy.nvim)

This config uses lazy.nvim's lockfile to pin plugin versions for reproducible setups.

- File: `lazy-lock.json` (commit this file)

#### Common tasks

- Update plugins, then write a new lockfile:
  - In Neovim: `:Lazy update` → `:Lazy lock`
  - Headless: `nvim --headless "+Lazy! update" "+Lazy! lock" +qa`

- Install exactly the pinned versions on a new machine:
  - In Neovim: `:Lazy restore`
  - Headless: `nvim --headless "+Lazy! restore" +qa`

- Sync (install missing and remove extras) using the lockfile:
  - In Neovim: `:Lazy sync`
  - Headless: `nvim --headless "+Lazy! sync" +qa`

- Remove plugins no longer referenced by specs:
  - In Neovim: `:Lazy clean`
  - Headless: `nvim --headless "+Lazy! clean" +qa`

#### Tips

- Only run `:Lazy lock` after successful updates. Commit the resulting `lazy-lock.json`.
- For testing this config in isolation, use a separate app name: `NVIM_APPNAME=nvim nvim`.
- If something breaks after updates, use `:Lazy restore` to roll back to the last known good lockfile.
