" configuration of options - type :options to get a list of all available
" options

set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set expandtab
set shiftwidth=4
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set colorcolumn=100
set signcolumn=auto:3
set background=dark
set nocompatible

" Ensure autocmd works for Filetype
set shortmess-=F

" Use system clipboard by default
set clipboard+=unnamedplus

nnoremap W :set wrap!<CR>
