" pathogen

call pathogen#infect()

" basics

set encoding=utf-8
set history=1000
set nocompatible            " don't need vi compatibility

" work with system clipboard

if has('mac')
  set clipboard=unnamed
elseif has('unix')
  set clipboard=unnamedplus
endif

" search and navigation

set ignorecase              " makes / searches case insensitive

" safety

set undofile
set noswapfile
set nobackup                " no backup after closing
set nowritebackup           " no backup while working
set undodir=/tmp/.vim_undo

" ui

set title                   " show title of file in menu bar
set ruler
set number                  " numbers on the left
set relativenumber
set scrolloff=1             " breathing room for zt
set laststatus=2
set term=screen-256color

" column width

set textwidth=80
set colorcolumn=+1

" indentation

set wrap
set formatoptions=qrn1
set autoindent              " always set autoindenting on
set shiftwidth=2            " number of spaces to use for autoindenting
set softtabstop=2
set tabstop=2

" mouse support
set mouse=a

" dangling spaces

autocmd BufWritePre * :%s/\s\+$//e " remove dangling spaces
match ErrorMsg /\s\+$/             " highlight dangling spaces

" restore cursor to saved position

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" solarized

syntax enable
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

