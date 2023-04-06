
filetype off

" Install with :PlugInstall
call plug#begin('~/.config/nvim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'junegunn/gv.vim'
    Plug 'preservim/nerdtree'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-lua/plenary.nvim'
    Plug 'BurntSushi/ripgrep'
    Plug 'neovim/nvim-lspconfig'
    Plug 'scalameta/nvim-metals'
    Plug 'mfussenegger/nvim-jdtls'
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'onsails/lspkind-nvim'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
    "Plug 'nvim-tree/nvim-tree.lua'
    " Required by lspsaga -- START:
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'nvim-treesitter/nvim-treesitter'
    " Required by lspsaga -- END:
    Plug '907th/vim-auto-save'
    Plug 'scrooloose/nerdcommenter'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'simrat39/symbols-outline.nvim'
    Plug 'nvim-telescope/telescope-live-grep-args.nvim'

    
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
" nnoremap <M-h> <C-^>

nnoremap J :res +5<CR>
nnoremap K :res -5<CR>
nnoremap L :vertical resize +5<CR>
nnoremap H :vertical resize -5<CR>

nnoremap _ <C-w>K
nnoremap + <C-w>J

"Buffer Management
"https://alpha2phi.medium.com/neovim-for-beginners-managing-buffers-91367668ce7
"previous buffer
nnoremap <M-left> <C-o>
"next buffer
nnoremap <M-right> <C-i>

packadd cfilter

" Replace highlighted text using space+r
vnoremap <leader>r "hy:%s/<C-r>h//gc<left><left><left>

" Replace all files in quickfix using space+r"
" cfdo executes the passed command (i.e. s/<before>/<after>/gc) in all files in quickfix list.
" note: 
" % = every line
" g = replace all occurences in file. 
" c = ask confirmation
nnoremap <leader>r "hy:cfdo %s///gc \| update<left><left><left><left><left><left><left><left><left><left><left><left><left>

" Create a new quickfix list with the highlighted entries:
vnoremap <leader>f "hy:Cfilter <C-r>h<CR>

" Create a new quickfix list without the highlighted entries:
vnoremap <leader>o "hy:Cfilter! <C-r>h<CR>

 " symbols-outline
nnoremap <M-7> :SymbolsOutline<CR>

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
"
"
" Works, but opens in firefox in remote shell... I want this in chrome at
" host.. gia ayto thelw kapoio plugin
"
"function! OpenURLUnderCursor()
  "let s:uri = expand('<cWORD>')
  "let s:uri = substitute(s:uri, '?', '\\?', '')
  "let s:uri = shellescape(s:uri, 1)
  "if s:uri != ''
    "silent exec "!open '".s:uri."'"
   ":redraw!
  "endif
"endfunction
"nnoremap gx :call OpenURLUnderCursor()<CR>
