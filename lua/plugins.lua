vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeFindFileToggle<CR>')

vim.keymap.set('n', '<leader>h', '<Cmd>HopWord<CR>', {silent = true})
vim.keymap.set('n', '<leader>H', '<Cmd>HopLine<CR>', {silent = true})
vim.keymap.set('n', '<leader>f', '<Cmd>HopWordCurrentLine<CR>', {silent = true})

vim.keymap.set({'n', 't'}, '<C-t>', function() vim.cmd(vim.v.count1 .. 'ToggleTerm') end, {silent = true})

return {
    {'petertriho/nvim-scrollbar', event = 'BufReadPost', config = function()
        require('scrollbar').setup()
    end},
    {'lewis6991/gitsigns.nvim', after = 'nvim-scrollbar', config = function()
        require('plugin_config.gitsigns')
    end},
    {'kevinhwang91/nvim-hlslens', after = 'nvim-scrollbar', config = function()
        require('scrollbar.handlers.search').setup{
            nearest_only = true,
        }
        local opts = {noremap = true, silent = true}
        vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
    end},

    {'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = {
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep',
    }, config = function()
        require('plugin_config.telescope')
    end},

    {'mg979/vim-visual-multi', event = 'BufReadPost'},

    {'folke/tokyonight.nvim', config = function()
        vim.cmd.colorscheme('tokyonight-day')
    end},
    {'nvim-lualine/lualine.nvim', config = function()
        require('lualine').setup{
            sections = {lualine_c = {{'filename', path = 1}}},
        }
    end},

    'kyazdani42/nvim-web-devicons',
    {'nvim-tree/nvim-tree.lua', cmd = 'NvimTreeFindFileToggle', config = function()
        require('nvim-tree').setup({
            renderer = {indent_markers = {enable = true}},
            tab = {sync = {open = true, close = true}},
            hijack_cursor = true,
            sync_root_with_cwd = true,
        })
    end},

    {'akinsho/bufferline.nvim', event = 'BufReadPost', config = function()
        require('bufferline').setup{options = {
            mode = 'tabs',
            max_name_length = 30,
        }}
    end},

    {'L3MON4D3/LuaSnip', tag = 'v<CurrentMajor>.*', config = function()
        require('plugin_config.luasnip')
    end},

    {'hrsh7th/nvim-cmp', event = 'BufReadPre', requires = {
        {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'},
        {'hrsh7th/cmp-buffer', after = 'nvim-cmp'},
        {'hrsh7th/cmp-path', after = 'nvim-cmp'},
        {'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp'},
        {'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp'},
    }, config = function()
        require('plugin_config.cmp')
    end},

    {'neovim/nvim-lspconfig', after = 'cmp-nvim-lsp', config = function()
        require('plugin_config.lspconfig')
    end},

    {'nvim-treesitter/nvim-treesitter', event = 'BufReadPost', run = function()
        local ts_update = require('nvim-treesitter.install').update({with_sync = true})
        ts_update()
    end, config = function()
        require('nvim-treesitter.configs').setup{
            ensure_installed = {'c', 'cpp', 'lua', 'python'},
            highlight = {enable = true},
        }
    end},

    {'phaazon/hop.nvim', branch = 'v2', cmd = {
        'HopWord', 'HopLine', 'HopWordCurrentLine',
    }, config = function()
        require('hop').setup()
    end},

    {'dstein64/vim-startuptime', cmd = 'StartupTime'},

    {'akinsho/toggleterm.nvim', cmd = 'ToggleTerm', config = function()
        require("toggleterm").setup()
    end},
}
