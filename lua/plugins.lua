vim.keymap.set('n', '<F3>', '<Cmd>NvimTreeFindFileToggle<CR>')

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

    'vim-syntastic/syntastic',
    'mg979/vim-visual-multi',

    {'skywind3000/vim-auto-popmenu', config = function()
        vim.g.apc_enable_ft = {c = 1, cpp = 1, lua = 1, python = 1}
        vim.opt.completeopt = "menu,menuone,noselect"
        vim.opt.shortmess:append('c')
    end},

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
            renderer = {indent_markers = {
                enable = true,
            }}
        })
    end},

    {'akinsho/bufferline.nvim', opt = true, event = 'BufReadPost', config = function()
        require("bufferline").setup{options = {
            mode = 'tabs',
            max_name_length = 30,
        }}
    end}
}
