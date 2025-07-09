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
    Plug 'nvim-tree/nvim-web-devicons'
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

call plug#end()

lua << EOF
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "lua", "javascript", "html", "css" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
})
require("nvim-tree").setup({
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 50,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
require("lualine").setup()
require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      "%.git/",
      "target",           -- Rust
      "%.o", "%.a",       -- 编译文件
      "__pycache__",
      "%.pyc",
      "venv/",
      "env/",
      "%.jpg", "%.png", "%.webp",
      "%.lock",
    },
  },
})
require("noice").setup()
require("mason").setup()
require("tint").setup({
  tint = -30,
  saturation = 0.6,  
  highlight_ignore_patterns = {
    "WinSeparator",
    "Status.*",
    "IndentBlankline.*",
  },
})
require('smear_cursor').setup({
})
require('barbar').setup({
    animation = true,
    auto_hide = false,
    tabpages = true,
    sidebar_filetypes = {
        NvimTree = true,
        dapui_watches = true,
    },
})
require("osc52").setup({
    silent = false,
    trim = false,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
      require('osc52').copy_register('+')
    end
  end,
})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
    root_dir = function(fname)
        local project_root = require("lspconfig.util").find_git_ancestor(fname)
        return project_root or vim.fn.expand("~/isaaclab")
    end,
    cmd = { "/isaac-sim/pyright_with_env.sh", "--stdio" },
    settings = {
        python = {
            pythonPath = "/isaac-sim/kit/python/bin/python3"
        }
    }   
})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})


local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})


local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
  },
})

local dap = require('dap')
dap.adapters.python = {
  type = 'executable',
  command = '/isaac-sim/python.sh',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      return '/isaac-sim/python.sh'
    end,
    cwd = '${workspaceFolder}',
  },
}

local dap_python = require('dap-python')
dap_python.setup('/isaac-sim/python.sh')

vim.keymap.set('n', '<leader>db', ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<leader>dc', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<leader>di', ":lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<leader>do', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<leader>dr', ":lua require'dap'.repl.toggle()<CR>")
vim.keymap.set('n', '<leader>du', ":lua require'dapui'.toggle()<CR>")

require("dapui").setup(
{
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 1 },
      },
      size = 10,
      position = "bottom",
    },
  },
})

vim.fn.sign_define('DapBreakpoint', { text='●', texthl='Error', linehl='', numhl='' })

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end



vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})


local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
--                 :BufferWipeout
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

map('n', '<C-A-p>',   '<Cmd>BufferPick<CR>', opts)
map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
vim.keymap.set('n', '<C-p>', ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
EOF


colorscheme tokyonight
