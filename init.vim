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

call plug#end()

colorscheme tokyonight

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
        dotfiles = false,
        git_ignored = false,
    },
})
require("lualine").setup({
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {  
        {
            function()
                return vim.fn.expand('%:~:.')
            end,
            color = { gui = 'bold' },
        },
    }, 

    lualine_x = {
        {
          function()
            local utc = os.time(os.date("!*t"))
            local jst = utc + 9 * 3600           
            return os.date("%H:%M:%S", jst)
          end,
          icon = '',
        },
        { 'encoding', 'fileformat', 'filetype' }
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})
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
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })


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
    { name = "vimtex" }
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
    env = {
        CUDA_VISIBLE_DEVICES = '1',
    }
  },
}

local dap_python = require('dap-python')
dap_python.setup('/isaac-sim/python.sh')

vim.keymap.set('n', '<leader>db', ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dc', ":lua require'dap'.continue()<CR>", { desc = "Continue Debugging" })
vim.keymap.set('n', '<leader>di', ":lua require'dap'.step_into()<CR>", { desc = "Step Into" })
vim.keymap.set('n', '<leader>do', ":lua require'dap'.step_over()<CR>", { desc = "Step Over" })
vim.keymap.set('n', '<leader>dr', ":lua require'dap'.repl.toggle()<CR>", { desc = "Toggle Debug REPL" })
vim.keymap.set('n', '<leader>du', function()
  if require("nvim-tree.api").tree.is_visible() then
    require("nvim-tree.api").tree.close()
  end
  require('dapui').toggle()
end, { desc = "Toggle Debug UI" })

vim.keymap.set('n', '<leader>dt', ":lua require'dap'.terminate()<CR>", { desc = "Terminate Debug Session" })

require('illuminate').configure({
    providers = {
        'lsp',
        'treesitter',
        'regex',
    },
    delay = 120,  
    large_file_cutoff = 2000,
    large_file_overrides = {
        providers = { 'regex' },
    },
    filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'fugitive',
        'NvimTree',
        'neo-tree',
        'dashboard',
        'alpha',
        'toggleterm',
        'TelescopePrompt',
        'Trouble',
        'Outline',
    },
    under_cursor = true,
    min_count_to_highlight = 2,
    disable_keymaps = true,
})


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



vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })

-- which-key config
require("which-key").setup({
  -- your configuration comes here
  -- for example, to enable the helix theme
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
  -- add helix theme
  preset = "helix",
})

-- auto-session config
require("auto-session").setup({
  log_level = "info",
  auto_restore_enabled = true,
  auto_session_enable_last_session = false,
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_dap_restore = true,
  auto_project_root_dir = vim.fn.getcwd(),
  bypass_session_save_file_types = { "gitcommit", "gitrebase" },
})

-- keymaps for auto-session
vim.keymap.set("n", "<leader>sr", require("auto-session.session-lens").search_session, {
  noremap = true,
  silent = true,
  desc = "Restore Session",
})
vim.keymap.set("n", "<leader>ss", "<cmd>SaveSession<CR>", {
  noremap = true,
  silent = true,
  desc = "Save Session",
})
vim.keymap.set("n", "<leader>sd", "<cmd>DeleteSession<CR>", {
  noremap = true,
  silent = true,
  desc = "Delete Session",
})
vim.keymap.set("n", "<leader>sl", "<cmd>LoadSession<CR>", {
  noremap = true,
  silent = true,
  desc = "Load Session",
})
vim.keymap.set("n", "<leader>sc", "<cmd>CloseSession<CR>", {
  noremap = true,
  silent = true,
  desc = "Close Session",
})



local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next buffer
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { desc = "Previous Buffer", noremap = true, silent = true })
map('n', '<A-.>', '<Cmd>BufferNext<CR>', { desc = "Next Buffer", noremap = true, silent = true })

-- Re-order buffer to previous/next
map('n', '<A-<', '<Cmd>BufferMovePrevious<CR>', { desc = "Move Buffer Previous", noremap = true, silent = true })
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { desc = "Move Buffer Next", noremap = true, silent = true })

-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { desc = "Go to Buffer 1", noremap = true, silent = true })
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { desc = "Go to Buffer 2", noremap = true, silent = true })
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { desc = "Go to Buffer 3", noremap = true, silent = true })
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { desc = "Go to Buffer 4", noremap = true, silent = true })
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { desc = "Go to Buffer 5", noremap = true, silent = true })
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { desc = "Go to Buffer 6", noremap = true, silent = true })
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { desc = "Go to Buffer 7", noremap = true, silent = true })
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { desc = "Go to Buffer 8", noremap = true, silent = true })
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { desc = "Go to Buffer 9", noremap = true, silent = true })
map('n', '<A-0>', '<Cmd>BufferLast<CR>', { desc = "Go to Last Buffer", noremap = true, silent = true })

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', { desc = "Pin/Unpin Buffer", noremap = true, silent = true })
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', { desc = "Close Buffer", noremap = true, silent = true })


map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', { desc = "Pick and Delete Buffer", noremap = true, silent = true })
vim.keymap.set('n', '<leader>f', '<Cmd>BufferPick<CR>', { desc = "Pick Buffer", noremap = true, silent = true })

map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = "Order Buffers by Number", noremap = true, silent = true })
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', { desc = "Order Buffers by Name", noremap = true, silent = true })
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', { desc = "Order Buffers by Directory", noremap = true, silent = true })
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = "Order Buffers by Language", noremap = true, silent = true })
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', { desc = "Order Buffers by Window Number", noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find Files (Telescope)" })
vim.keymap.set("n", "<C-b>", function()
  pcall(function() require("dapui").close() end)
  vim.cmd("NvimTreeToggle")
end, { noremap = true, silent = true, desc = "Toggle NvimTree" })

map('n', '<A-s>', '<Cmd>wa<CR>', { desc = "Save All Buffers", noremap = true, silent = true })
map('i', '<S-Tab>', '<C-d>', { desc = "Indent Line", noremap = true, silent = true })

require("toggleterm").setup{
    size = 15,
    shell = "/usr/bin/zsh",
    open_mapping = [[<c-\>]],
    direction = 'float', 
}

function LineNumberColors()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#7aa2f7', bold=false })
    vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#f7768e', bold=false })
end

LineNumberColors()

-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         require("duck").hatch("🐈")
--     end,
-- })


map('n', '<C-d>', "15jzz", { desc = "Scroll Down 10 Lines", noremap = true, silent = true })
map('n', '<C-u>', "15kzz", { desc = "Scroll Up 10 Lines", noremap = true, silent = true })

-- comment
require('Comment').setup()

map('n', '<C-/>', '<Plug>(comment_toggle_linewise_current)', { desc = "Toggle Comment", noremap = true, silent = true })
map('v', '<C-/>', '<Plug>(comment_toggle_linewise_visual)', { desc = "Toggle Comment", noremap = true, silent = true })

-- leap.nvim
require('leap').add_default_mappings()

-- vimtex configuration
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_latexmk = {
    build_dir = 'build',
    callback = 1,
    continuous = 1,
    options = {
        '-xelatex',
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
    },
}

vim.g.tex_conceal = 'abdmg'

map('n', '<leader>ll', ':VimtexCompile<CR>', { desc = "Compile LaTeX", noremap = true, silent = true })
map('n', '<leader>lv', ':VimtexView<CR>', { desc = "View LaTeX", noremap = true, silent = true })
map('n', '<leader>lc', ':VimtexClean<CR>', { desc = "Clean LaTeX", noremap = true, silent = true })

-- vim-window-picker configuration
require('window-picker').setup({
    hint = 'floating-big-letter',
    autoselect_one = true,
    include_current = false,
    selection_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    filter_rules = {
        bo = {
            filetype = { 'NvimTree', 'TelescopePrompt', 'toggleterm', 'dapui_watches' },
            buftype = { 'terminal', 'quickfix' },
        },
    },
    other_win_hl_color = '#e35e4f',
})
vim.keymap.set('n', '<leader>w', function()
  local picked_window_id = require('window-picker').pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end, { desc = 'Pick a window' })

EOF


