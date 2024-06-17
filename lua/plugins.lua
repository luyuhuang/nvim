return {
    {'petertriho/nvim-scrollbar', event = 'BufReadPost', config = function()
        require('scrollbar').setup()
    end},
    {'lewis6991/gitsigns.nvim', event = 'BufReadPost', dependencies = {
        'petertriho/nvim-scrollbar'
    }, config = function()
        require('plugin_config.gitsigns')
    end},
    {'kevinhwang91/nvim-hlslens', event = 'BufReadPost', dependencies = {
        'petertriho/nvim-scrollbar'
    }, config = function()
        require('scrollbar.handlers.search').setup{
            nearest_only = true,
        }
        local opts = {noremap = true, silent = true}
        vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
        vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
    end},

    {'nvim-telescope/telescope.nvim', event = 'BufReadPost', keys = {
        '<leader>s', '<C-p>',
    }, cmd = {
        'Glg', 'Gst', 'Diag', 'Tags'
    }, dependencies = {
        {'nvim-lua/plenary.nvim'},
        {'BurntSushi/ripgrep'},
    }, config = function()
        require('plugin_config.telescope')
    end},

    {'mg979/vim-visual-multi', keys = {{'<C-n>', mode = {'n', 'v'}}, '<C-Down>', '<C-Up>'}, config = function()
        vim.g.VM_maps = {['I BS'] = ''}
        vim.g.VM_silent_exit = 1
        vim.g.VM_plugins_compatibilty = {['lualine.nvim'] = {
            test = function() return true end,
            enable = 'lua require("lualine").hide{unhide = true}',
            disable = 'lua require("lualine").hide()',
        }}
        vim.g.VM_Mono_hl = 'Cursor'
        vim.g.VM_Extend_hl  = 'Visual'
    end},

    {'folke/tokyonight.nvim', dependencies = 'nvim-lualine/lualine.nvim', config = function()
        vim.cmd.colorscheme('tokyonight-day')
    end},
    {'nvim-lualine/lualine.nvim', config = function()
        require('lualine').setup{
            options = {globalstatus = true},
            sections = {lualine_c = {{'filename', path = 1}}},
        }
    end},

    'kyazdani42/nvim-web-devicons',
    {'nvim-tree/nvim-tree.lua', keys = {
        {'<F3>', '<Cmd>NvimTreeFindFileToggle<CR>', mode = {'n', 'i', 't'}},
    }, config = function()
        require('plugin_config.tree')
    end},

    {'akinsho/bufferline.nvim', event = 'BufReadPost', config = function()
        require('plugin_config.bufferline')
    end},

    {'L3MON4D3/LuaSnip', event = 'InsertEnter', config = function()
        require('plugin_config.luasnip')
    end},

    {'hrsh7th/nvim-cmp', event = {'BufReadPre', 'CmdlineEnter'}, dependencies = {
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-cmdline'},
        {'quangnguyen30192/cmp-nvim-tags'},
        {'saadparwaiz1/cmp_luasnip'},
    }, config = function()
        require('plugin_config.cmp')
    end},

    {'neovim/nvim-lspconfig', event = 'BufReadPre', dependencies = {
        'hrsh7th/cmp-nvim-lsp'
    }, config = function()
        require('plugin_config.lspconfig')
    end},

    {'nvim-treesitter/nvim-treesitter', event = 'BufReadPost', build = function()
        local ts_update = require('nvim-treesitter.install').update({with_sync = true})
        ts_update()
    end, config = function()
        require('nvim-treesitter.configs').setup{
            ensure_installed = {'c', 'cpp', 'lua', 'python'},
            highlight = {enable = true},
        }
    end},

    {'phaazon/hop.nvim', branch = 'v2', keys = {
        {'<leader>h', '<Cmd>HopWord<CR>', mode = 'n', silent = true},
        {'<leader>H', '<Cmd>HopLine<CR>', mode = 'n', silent = true},
        {'<leader>f', '<Cmd>HopWordCurrentLine<CR>', mode = 'n', silent = true},
    }, config = function()
        require('hop').setup()
    end},

    {'akinsho/toggleterm.nvim', keys = {
        {'<C-t>', function() vim.cmd(vim.v.count1 .. 'ToggleTerm') end, mode = {'n', 't'}, silent = true},
    }, config = function()
        require("toggleterm").setup()
    end},

    {'windwp/nvim-autopairs', event = 'InsertEnter', opts = {
        map_bs = true,
        disable_filetype = {'TelescopePrompt', 'scheme', 'lisp', 'racket'}
    }},

    {'nmac427/guess-indent.nvim', event = 'BufReadPre', name = 'guess-indent', opts = {
        auto_cmd = true,
        filetype_exclude = {'scheme', 'lisp', 'racket'},
    }},

    {'terrortylor/nvim-comment', keys = {
        {'<C-_>', '<Cmd>CommentToggle<CR>', mode = 'n'},
        {'<C-_>', ':CommentToggle<CR>', mode = 'v'},
    }, name = 'nvim_comment', opts = {create_mappings = false}},

    {'junegunn/vim-easy-align', keys = {{'ga', '<Plug>(EasyAlign)', mode = 'x'}}},

    {'kylechui/nvim-surround', keys = {
        'ds', 'cs', {'s', mode = 'v'}
    }, opts = {keymaps = {
        insert = false, insert_line = false, normal = false, normal_cur = false,
        normal_cur_line = false, visual_line = false, visual = 's',
    }}},

    {'gpanders/nvim-parinfer', ft = {'scheme', 'lisp', 'racket'}},
}
