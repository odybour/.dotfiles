
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
