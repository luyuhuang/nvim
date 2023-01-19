vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeFindFileToggle<CR>')

vim.keymap.set('n', '<leader>h', '<Cmd>HopWord<CR>', {silent = true})
vim.keymap.set('n', '<leader>H', '<Cmd>HopLine<CR>', {silent = true})
vim.keymap.set('n', '<leader>f', '<Cmd>HopWordCurrentLine<CR>', {silent = true})

return {
    {'lewis6991/gitsigns.nvim', config = function()
        require('plugin_config.gitsigns')
    end},

    {"kevinhwang91/nvim-hlslens", config = function()
        require("scrollbar.handlers.search").setup{
            nearest_only = true,
        }
        local opts = {noremap = true, silent = true}
        vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
    end},
    {"petertriho/nvim-scrollbar", config = function()
        require("scrollbar").setup()
    end},

    {'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = {
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep',
    }, config = function()
        require('plugin_config.telescope')
    end},

    'mg979/vim-visual-multi',

    {'folke/tokyonight.nvim', config = function()
        vim.cmd.colorscheme('tokyonight-day')
    end},
    {'nvim-lualine/lualine.nvim', config = function()
        require('lualine').setup{
            sections = {lualine_c = {{'filename', path = 1}}},
        }
    end},

    'kyazdani42/nvim-web-devicons',
    {'nvim-tree/nvim-tree.lua', opt = true, cmd = {'NvimTreeFindFileToggle'}, config = function()
        require("nvim-tree").setup({
            renderer = {indent_markers = {enable = true}},
            tab = {sync = {open = true, close = true}},
            hijack_cursor = true,
            sync_root_with_cwd = true,
        })
    end},

    {'akinsho/bufferline.nvim', opt = true, event = 'BufReadPost', config = function()
        require("bufferline").setup{options = {
            mode = 'tabs',
            max_name_length = 30,
        }}
    end},

    {'neovim/nvim-lspconfig', config = function()
        require('plugin_config.lspconfig')
    end},

    {"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*", config = function()
        require('plugin_config.luasnip')
    end},

    {'hrsh7th/nvim-cmp', requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'quangnguyen30192/cmp-nvim-tags',
        'saadparwaiz1/cmp_luasnip',
    }, config = function()
        require('plugin_config.cmp')
    end},

    {'nvim-treesitter/nvim-treesitter', opt = true, event = "BufReadPost", run = function()
        local ts_update = require('nvim-treesitter.install').update({with_sync = true})
        ts_update()
    end, config = function()
        require('nvim-treesitter.configs').setup{
            ensure_installed = {'c', 'cpp', 'lua', 'python'},
            highlight = {enable = true},
        }
    end},

    {'phaazon/hop.nvim', branch = 'v2', opt = true, cmd = {
        'HopWord', 'HopLine', 'HopWordCurrentLine',
    }, config = function()
        require('hop').setup()
    end},

}
