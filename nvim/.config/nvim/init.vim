
filetype off

call plug#begin('~/.config/nvim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'scalameta/nvim-metals'
    Plug 'mfussenegger/nvim-dap'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
    Plug '907th/vim-auto-save'

call plug#end()

filetype plugin indent on
syntax on

let mapleader = " "

lua require("ody")

" Map window key to <alt+w>, then map horizontal and vertical window split keys
nnoremap <M-w> <C-w>
nnoremap <M-w>k <C-w>s
nnoremap <M-w>l <C-w>v

nnoremap <leader>pv :Ex<CR>

" Map alternate file to <alt-h>
nnoremap <M-h> <C-^>

"function! GoBackToRecentBuffer()
"  let startName = bufname('%')
"  while 1
"    exe "normal! \<c-o>"
"    let nowName = bufname('%')
"    if nowName != startName
"      break
"    endif
"  endwhile
"ndfunction
"
"nnoremap <silent> <M-h> :call GoBackToRecentBuffer()<Enter>