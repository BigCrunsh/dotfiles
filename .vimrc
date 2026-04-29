" basics
set encoding=utf-8
set history=1000
set nocompatible

" system clipboard
if has('mac')
  set clipboard=unnamed
elseif has('unix')
  set clipboard=unnamedplus
endif

" search
set ignorecase
set smartcase
set hlsearch
set incsearch

" persistent undo
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', 'p')
endif
set undofile
set undodir=~/.vim/undo
set noswapfile
set nobackup
set nowritebackup

" ui
set title
set ruler
set number
set relativenumber
set scrolloff=1
set laststatus=2

" column width
set textwidth=80
set colorcolumn=+1

" backspacing
set backspace=indent,eol,start

" indentation
set wrap
set formatoptions=qrn1
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" filetypes
filetype plugin indent on

" python: 4-space indent (PEP 8)
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4

" mouse
set mouse=a

" highlight trailing whitespace (don't auto-strip)
match ErrorMsg /\s\+$/

" restore cursor to last position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" colors: solarized light
syntax enable
set background=light
let g:solarized_termcolors=256
colorscheme solarized
