### Neovim Config

#### Bootstrap

1) Install prerequisites (macOS/Homebrew):

```bash
brew install neovim ripgrep fd lazygit yazi pngpaste node pnpm go rust zellij git jq glow lux
```

2) Optional: isolate this config (recommended for testing):

```bash
export NVIM_APPNAME=nvim
```

3) First-time setup:

```bash
nvim --headless "+Lazy! sync" +qa
```

4) Lux-based checks:

```bash
lx test
lx fmt
lx lint
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

#### Project tooling (Lux)

This repo also uses Lux for Lua project metadata and local checks.

- Files: `lux.toml`, `lux.lock`
- Primary command: `lx test`

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

#### Keymaps

Global:
- `jk` / `jj` (insert): exit insert mode
- `<C-h/j/k/l>`: move between windows
- `<C-Up/Down/Left/Right>`: resize window
- `<C-d>` / `<C-u>`: half-page scroll + center
- `<leader>w`: write buffer
- `<leader>qq`: quit window
- `<leader>y` / `<leader>Y`: yank to system clipboard
- `<leader>p` / `<leader>P`: paste from clipboard / keep register paste
- `<leader>uh`: clear search highlight
- `<leader>n` / `<leader>N`: next/prev diagnostic (optimized for QWERTZ)
- `<leader>cl`: copy `path:line`
- `<CR>`: clear search highlight if active, else normal Enter

#### QWERTZ Layout
The config is optimized for German keyboards where `[` and `]` are hard to reach:
- `LocalLeader` is `,` (comma) instead of `\` (`AltGr+ß`).
- `<leader>n` and `<leader>N` are used as ergonomic alternatives for `]d`/`]h` and `[d`/`[h`, mirroring Neovim's `n`/`N` search behavior.
- `y` (yank) is in the bottom-left position on QWERTZ, which is very ergonomic for frequent use.

Code (`<leader>c`):
- `<leader>ca`: code action
- `<leader>cr`: rename symbol
- `<leader>cf`: format buffer
- `<leader>cs`: document symbols
- `<leader>cd`: line diagnostics float
- `<leader>cD`: generate docs (neogen)
- `<leader>ct`: todo comments picker
- `<leader>cT`: todo/fix/fixme picker
- `<leader>cn` / `<leader>cp`: next/prev reference

LSP / Go-to:
- `K`: hover
- `gd`: definition
- `gD`: declaration
- `gI`: implementation
- `gR` / `gr`: references
- `gy`: type definition
- `gai` / `gao`: incoming/outgoing calls
- `[d` / `]d`: prev/next diagnostic

Find (`<leader>f`):
- `<leader><space>`: smart file open (NeuralOpen)
- `<leader>/`: grep
- `<leader>:`: command history
- `<leader>fc`: config files
- `<leader>ff`: find files
- `<leader>fg`: grep
- `<leader>fr`: recent files
- `<leader>fp`: projects
- `<leader>fb`: buffers
- `<leader>fh`: help

Search (`<leader>s`):
- `<leader>sa`: autocmds
- `<leader>sb` / `<leader>sB`: buffer lines / grep open buffers
- `<leader>sc` / `<leader>sC`: command history / commands
- `<leader>sg`: grep
- `<leader>sw`: grep word/selection
- `<leader>sd` / `<leader>sD`: diagnostics / buffer diagnostics
- `<leader>sh`: help picker
- `<leader>sj`: jumps
- `<leader>sk`: keymaps picker
- `<leader>sl`: location list
- `<leader>sm`: marks
- `<leader>sq`: quickfix list
- `<leader>sR`: resume last picker
- `<leader>ss`: LSP symbols
- `<leader>sS`: workspace symbols
- `<leader>sr`: replace in files (spectre)
- `<leader>su`: undo history

Buffers (`<leader>b`):
- `<leader>bb`: buffer list
- `<leader>bn`: next buffer
- `<leader>bp`: previous buffer
- `<leader>bd`: delete buffer
- `<leader>bD`: force delete buffer
- `<leader>,`: buffers picker

Git (`<leader>g`):
- `<leader>gb`: branches
- `<leader>gs`: status
- `<leader>gS`: stash
- `<leader>gl`: log
- `<leader>gL`: log line
- `<leader>gf`: log file
- `<leader>gn`: open neogit
- `<leader>gd`: VscodeDiff
- `<leader>gO`: toggle mini.diff overlay

Hunks / History:
- `[h` / `]h`: prev/next hunk
- `[H` / `]H`: first/last hunk
- `gh` / `gH`: apply/reset hunk operator
- `<leader>hp` / `<leader>hn`: alt prev/next hunk
- `<leader>hs` / `<leader>hS`: git pickaxe search (buffer/global)
- `<leader>ha` / `<leader>ht` / `<leader>hl`: haunt annotate/toggle/list

Debug (`<leader>d`):
- `<leader>db`: toggle breakpoint
- `<leader>dB`: conditional breakpoint
- `<leader>dc`: continue
- `<leader>di`: step into
- `<leader>do`: step over
- `<leader>dO`: step out
- `<leader>dr`: open REPL
- `<leader>du`: toggle dap view
- `<leader>dd` (rust ft): rust debuggables

Tests (`<leader>t`):
- `<leader>tt`: run nearest
- `<leader>tf`: run file
- `<leader>ta`: run all
- `<leader>tl`: run last
- `<leader>ts`: toggle summary
- `<leader>to`: open output
- `<leader>tO`: toggle output panel
- `<leader>tw`: toggle watch

UI / Toggles (`<leader>u`):
- `<leader>uC`: colorschemes
- `<leader>ut`: terminal toggle
- `<C-/>` / `<C-_>`: terminal toggle
- `<leader>us`: toggle spell
- `<leader>uw`: toggle wrap
- `<leader>uL`: toggle relative numbers
- `<leader>ul`: toggle line numbers
- `<leader>ud`: toggle diagnostics
- `<leader>uT`: toggle treesitter
- `<leader>ui`: toggle inlay hints
- `<leader>un` / `<leader>uN`: dismiss/show noice notifications
- `<leader>utc`: toggle context mode
- `<leader>uta`: auto context mode

Navigation / Files:
- `<leader>-`: open Oil
- `-` (normal/visual): open Yazi
- `<leader>vy` / `<leader>vd`: add/remove visits label
- `<leader>vY`: select labeled visit
- `<leader>v1` / `v2` / `v3` / `v4`: visits first/back/forward/last

Sessions (`<leader>q`):
- `<leader>qs`: restore session
- `<leader>qS`: select session
- `<leader>ql`: restore last session
- `<leader>qd`: disable current session save

Tasks (`<leader>x`):
- `<leader>xw`: task list
- `<leader>xo`: run task
- `<leader>xi`: task info
- `<leader>xb`: task builder
- `<leader>xt`: task action
- `<leader>xc`: clear task cache
- `<leader>xx` / `<leader>xX` / `<leader>xq` / `<leader>xl`: trouble views

AI (`<leader>a`):
- `<C-.>`: toggle sidekick CLI
- `<leader>aa`: toggle CLI
- `<leader>as`: select CLI
- `<leader>ad`: detach CLI
- `<leader>af`: send file
- `<leader>at`: send this
- `<leader>av`: send selection
- `<leader>ap`: prompt
- `<leader>ac`: toggle cursor session
- `<leader>aV`: load VectorCode

Knowledge / Notes / Markdown / Obsidian:
- `<leader>kt`: neovim tips (Knowledge)
- `<leader>mp`: markdown preview split
- `<leader>op` / `<leader>oh` / `<leader>ow`: open personal/htwk/work vault
- `<leader>on`: new obsidian note
- `<leader>os`: obsidian search
- `<leader>oq`: obsidian quick switch
- `<leader>oo`: open daily note in split (vault picker)

Zellij (`<leader>z`):
- `<leader>zh` / `zj` / `zk` / `zl`: zellij navigate left/down/up/right
