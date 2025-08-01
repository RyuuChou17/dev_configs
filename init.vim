" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set encoding=utf-8

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

let skip_defaults_vim=1

set nu rnu

syntax enable

call plug#begin('~/.local/share/nvim/plugged')

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim' 
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'folke/tokyonight.nvim'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'folke/noice.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'levouh/tint.nvim'
    Plug 'sphamba/smear-cursor.nvim'
    Plug 'romgrk/barbar.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'nvimtools/none-ls.nvim'
    Plug 'github/copilot.vim'
    Plug 'ojroques/nvim-osc52'
    Plug 'mfussenegger/nvim-dap'                         
    Plug 'nvim-neotest/nvim-nio'
    Plug 'rcarriga/nvim-dap-ui'                         
    Plug 'nvim-telescope/telescope-dap.nvim'           
    Plug 'theHamsta/nvim-dap-virtual-text'            
    Plug 'mfussenegger/nvim-dap-python'
    Plug 'folke/which-key.nvim'
    Plug 'rmagatti/auto-session'
    Plug 'rmagatti/session-lens'
    Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
    Plug 'RRethy/vim-illuminate'
    Plug 'tamton-aquib/duck.nvim'
    Plug 'numToStr/Comment.nvim'
    Plug 'ggandor/leap.nvim'
    Plug 'lervag/vimtex'
    Plug 's1n7ax/nvim-window-picker',
    Plug 'nvim-treesitter/nvim-treesitter-context',
    Plug 'stevearc/aerial.nvim',
    Plug 'folke/flash.nvim'
    Plug 'phaazon/hop.nvim',
    Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} 
    Plug 'iurimateus/luasnip-latex-snippets.nvim'

call plug#end()

colorscheme tokyonight

lua require("main")
