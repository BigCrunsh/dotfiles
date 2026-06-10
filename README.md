# Dotfiles

Personal macOS configs and a one-command bootstrap.

## Quick start

```bash
git clone git@github.com:bigcrunsh/dotfiles
cd dotfiles
./pin
```

(Clone wherever you keep your repos — `pin` resolves its own location, so it works regardless of clone path.)

The script is idempotent — safe to re-run.

## What `./pin` does

1. Installs Homebrew if missing.
2. Installs packages from [`Brewfile`](Brewfile).
3. Symlinks dotfiles into `~`. Existing real files are backed up to `*.backup.<timestamp>`.
4. Bootstraps [tpm](https://github.com/tmux-plugins/tpm) and installs tmux plugins.
5. Registers [nbdime](https://nbdime.readthedocs.io/) as the git diff/merge driver for `.ipynb`.
6. Sets `zsh` as the login shell.

## What's inside

- **zsh** — robbyrussell-style prompt with venv / git status / command-duration / SSH-host indicators, prefix-aware history search, [autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) plugins
- **tmux** — vim-style bindings, mouse on, [catppuccin](https://github.com/catppuccin/tmux) (latte) theme via tpm
- **vim** — solarized light, persistent undo, sane defaults; no plugin manager (Vim 8+ native packages)
- **git** — modern defaults (`zdiff3` conflicts, `autoStash`, `rerere`, histogram diff), [delta](https://github.com/dandavison/delta) pager, work-email override via `includeIf`
- **ssh** — delegates auth to the [1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/)
- **bin/** — small utility scripts
- **Brewfile** — system dependencies installed via `brew bundle`

## Manual steps after bootstrap

- Open a new terminal so the new shell config loads.
- In 1Password → Settings → Developer → toggle **Use the SSH agent**.
- For per-machine SSH host overrides, create `~/.ssh/config.local` (gitignored).
- In iTerm → Settings (⌘,) → Keys → Key Bindings → `+`, add two entries so `⌘T`/`⌘N` don't auto-attach a second client to the same tmux session (which causes duplicated I/O):

  | Shortcut | Action | Value | What it does |
  |---|---|---|---|
  | `⌘T` | Send Hex Codes | `0x1 0x63` | Sends `prefix c` → new tmux window |
  | `⌘N` | Ignore | *(none)* | `⌘N` becomes a no-op |

## Cheat sheet

Most useful shortcuts in this setup. **Bold** marks custom bindings from this repo; the rest are defaults worth remembering.

### zsh

| Key / command | What |
|---|---|
| `↑` / `↓` | **Prefix-aware history search** — type `git ` then ↑ to cycle only past commands starting with `git ` |
| `Ctrl-R` | Fuzzy reverse history search (any substring) |
| `Ctrl-A` / `Ctrl-E` | Start / end of line |
| `Alt-B` / `Alt-F` | Word back / forward |
| `Ctrl-W` / `Alt-D` | Delete word back / forward |
| `Ctrl-U` / `Ctrl-K` | Kill to start / end of line |
| `Ctrl-Y` | Yank (paste killed text) |
| `Ctrl-L` | Clear visible screen |
| `Cmd-K` | Clear scrollback (iTerm) |
| `Ctrl-Z` → `fg` / `bg` | Suspend / resume foreground job |
| `<space>cmd` | Leading space keeps the command out of history |
| `..` / `...` / `....` | `cd ..` / `cd ../..` / `cd ../../..` |
| `z <name>` | [zoxide](https://github.com/ajeetdsouza/zoxide) — jump to the most-frecent dir matching `<name>` |
| `zi <name>` | zoxide interactive picker |
| `pbcopy` / `pbpaste` | Pipe to / from macOS clipboard |
| `pyenv shell 3.12` | Python version for current shell |
| `pyenv local 3.11` | Pin Python for current dir (writes `.python-version`) |

> **Alt = Option (⌥)** on macOS. In iTerm: Settings → Profiles → Keys → "Left Option key acts as: Esc+" to enable. Otherwise `Esc` then the key works as a substitute (`Esc B` = `Alt-B`).

### tmux (prefix = `Ctrl-A`)

Press prefix, **release**, then the key — it's a sequence, not a chord.

**Custom bindings:**

| Binding | Action |
|---|---|
| `prefix \|` | **Split vertical** (opens in current pane's cwd) |
| `prefix -` | **Split horizontal** (opens in current pane's cwd) |
| `prefix Ctrl-h/j/k/l` | **Move between panes** (vim-style, repeatable) |
| `prefix H/J/K/L` | **Resize pane** left/down/up/right (repeatable) |
| `prefix r` | **Reload `~/.tmux.conf`** |
| `prefix R` | **Rotate panes** within window |
| `v` (in copy mode) | Start selection (vi style) |
| `y` (in copy mode) | Copy to macOS clipboard via `pbcopy` |
| Mouse drag end | Auto-copy selection to macOS clipboard |

**Useful defaults:**

| Binding | Action |
|---|---|
| `prefix z` | **Toggle pane zoom** — fullscreen the current pane and back; the single most useful binding in tmux |
| `prefix d` | Detach session |
| `prefix s` | Switch session (interactive list) |
| `prefix c` / `,` / `&` | New / rename / kill window |
| `prefix n` / `p` / `1`–`9` | Next / prev window / jump to N |
| `prefix x` | Kill pane |
| `prefix !` | Break pane to new window |
| `prefix [` | Enter copy mode (mouse scroll also enters it) |
| `prefix ]` | Paste tmux buffer |
| `prefix :` / `?` | Command prompt / list all bindings |

**From the shell:**

```
tmux                  # attach to last session, or create one
tmux ls               # list sessions
tmux new -s <name>    # new named session
tmux a -t <name>      # attach to named session
tmux kill-server      # nuke everything
```

Hold **Option (⌥)** while mouse-selecting to bypass tmux mouse mode and use iTerm's native selection (useful across panes).

### vim

| Key | Action |
|---|---|
| `i` / `a` / `o` | Insert before / after / new line below |
| `Esc` or `Ctrl-[` | Back to normal mode |
| `h j k l` | Move left/down/up/right |
| `w` / `b` / `e` | Word forward / back / end |
| `0` / `^` / `$` | Start / first non-blank / end of line |
| `gg` / `G` / `<n>G` | Top / bottom / line N |
| `Ctrl-D` / `Ctrl-U` | Half page down / up |
| `*` / `#` | Search word under cursor forward / back |
| `dd` / `cc` / `yy` | Delete / change / yank line |
| `dw` / `cw` / `yw` | Delete / change / yank word |
| `p` / `P` | Paste after / before cursor |
| `u` / `Ctrl-R` | Undo / redo (persistent across sessions) |
| `.` | Repeat last change |
| `>>` / `<<` | Indent / dedent |
| `ciw` / `ci"` / `ci{` | Change inner word / quotes / braces |
| `/foo` then `n` / `N` | Search / next / previous match |
| `:%s/foo/bar/g` | Replace all (`/gc` to confirm each) |
| `:noh` | Clear search highlight |
| `:w` / `:q` / `:wq` / `:q!` | Save / quit / save+quit / force quit |
| `:e <file>` | Open file |
| `:sp` / `:vsp` | Horizontal / vertical split |
| `Ctrl-W h/j/k/l` | Move between splits |
| `m{a-z}` / `` `a `` | Set mark / jump to mark |
| `Ctrl-O` / `Ctrl-I` | Jump back / forward in jumplist |

This config sets `clipboard=unnamed`, so `y` and `p` go through the macOS clipboard automatically — `yy` then `Cmd-V` in any other app just works.

### git

| Command | What |
|---|---|
| `git lola` | Pretty graph log of all branches (alias) |
| `git co` / `ci` | `checkout` / `commit` (aliases) |
| `delete-merged-branches [-n]` | Delete local branches merged into the default branch (`-n` for dry run) |
| `nbdime` | Auto-runs as the diff/merge driver for `.ipynb` |
| Conflicts | `zdiff3` style — markers include the common ancestor for easier resolution |

## Layout

| Path | Purpose |
|------|---------|
| [`.zshrc`](.zshrc) | shell config |
| [`.tmux.conf`](.tmux.conf) | tmux config |
| [`.vimrc`](.vimrc) + [`.vim/colors/`](.vim/colors/) | vim config and solarized colorscheme |
| [`.gitconfig`](.gitconfig) | git config; work email auto-applies in `~/src/github.com/fitanalytics/` |
| [`.gitconfig-work`](.gitconfig-work) | included by `.gitconfig` for work repos |
| [`.gitignore`](.gitignore) | global git excludes |
| [`.ssh/config`](.ssh/config) | SSH config (delegates to 1Password agent) |
| [`Brewfile`](Brewfile) | Homebrew dependencies |
| [`bin/`](bin/) | utility scripts |
| [`pin`](pin) | install script |

## Credits

Originally based on [@purzelrakete's dotfiles](https://github.com/purzelrakete/dotfiles).
