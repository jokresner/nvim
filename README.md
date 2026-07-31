# Modular Neovim Configuration

A heavily customized, QWERTZ-optimized Neovim 0.10+ environment tailored for Go, Rust, and PHP.

## Core Stack
- **Plugin Manager:** `lazy.nvim`
- **UI & Dashboard:** `snacks.nvim` + `noice.nvim`
- **Editing:** `mini.nvim` (AI, Surround, Comment) + `blink.cmp` + `supermaven-nvim`
- **Files & Search:** `yazi.nvim` + `fff.nvim`
- **Git:** `mini.diff` + `snacks.lazygit` + `codediff.nvim`
- **Testing & Debug:** `neotest` + `nvim-dap` + `nvim-dap-view`


## Keymap Taxonomy
- `<leader><leader>`: file finder (`fff.nvim`)
- `<leader>,`: buffer picker
- `<leader>f`: files (`fr` recent, `fp` projects, `fl` copy file:line)
- `<leader>s`: search (`sg` grep, `sG` fuzzy grep, `sw` word, `sk` keymaps, `sh` help, `sr` resume, `su` undo, `ss` symbols, `sS` workspace symbols, `st` TODO, `sT` TODO/FIX)
- `<leader>c`: code actions (`ca` action, `cr` rename, `cf` format, `cn`/`cp` references)
- `<leader>x`: diagnostics (`xd` line, `xx` list, `xb` buffer, `xq` quickfix, `xl` loclist); `<leader>n`/`<leader>N` move next/previous
- `<leader>t`: tests (`tn` nearest, `tf` file, `ta` all, `tl` last, `ts` summary, `to` output, `tO` output panel, `tw` watch)
- `<leader>d`: debug, `<leader>g`: git (`gd` status, `gm` diff from main, `gM` diff with main, `gf` file diff from main, `gF` file diff with main, `gL` current line diff, `gl` lazygit), `<leader>a`: AI, `<leader>u`: UI/toggles, `<leader>m`: markdown

QWERTZ constraint: avoid mappings that require `[` or `]`.

## Installation
```bash
# Backup your old config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repo
git clone <your-repo-url> ~/.config/nvim

# Start Neovim (Lazy will install everything automatically)
nvim
```
