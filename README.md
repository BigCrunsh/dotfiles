# Dotfiles

Personal macOS configs and a one-command bootstrap.

## Quick start

```bash
git clone git@github.com:bigcrunsh/dotfiles ~/dotfiles
cd ~/dotfiles
./pin
```

The script is idempotent — safe to re-run.

## What `./pin` does

1. Installs Homebrew if missing.
2. Installs packages from [`Brewfile`](Brewfile).
3. Symlinks dotfiles into `~`. Existing real files are backed up to `*.backup.<timestamp>`.
4. Bootstraps [tpm](https://github.com/tmux-plugins/tpm) and installs tmux plugins.
5. Registers [nbdime](https://nbdime.readthedocs.io/) as the git diff/merge driver for `.ipynb`.
6. Sets `zsh` as the login shell.

## What's inside

- **zsh** — minimal config, prefix-aware history search, `vcs_info` git prompt
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
