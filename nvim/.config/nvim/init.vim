
filetype off

" Install with :PlugInstall
call plug#begin('~/.config/nvim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'junegunn/gv.vim'
    Plug 'preservim/nerdtree'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'scalameta/nvim-metals'
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
    Plug '907th/vim-auto-save'
    Plug 'scrooloose/nerdcommenter'

call plug#end()

filetype plugin indent on
syntax on

let mapleader = " "

lua require("ody")

" Map window key to <alt+w>, then map horizontal and vertical window split keys
nnoremap <M-w> <C-w>
nnoremap <M-w>[ <C-w>s
nnoremap <M-w>] <C-w>v
nnoremap <M-w>k <C-w><Up>
nnoremap <M-w>h <C-w><Left>
nnoremap <M-w>j <C-w><Down>
nnoremap <M-w>l <C-w><Right>

nnoremap <leader>pv :Ex<CR>

" Map alternate file to <alt-h>
nnoremap <M-h> <C-^>

nnoremap ( :res +5<CR>
nnoremap ) :res -5<CR>
nnoremap > :vertical resize +5<CR>
nnoremap < :vertical resize -5<CR>

nnoremap _ <C-w>K
nnoremap + <C-w>J

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
