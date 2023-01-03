require('packer').startup(function(use)
    use{'lewis6991/gitsigns.nvim', config = function()
        require('gitsigns').setup{current_line_blame = true}
        require("scrollbar.handlers.gitsigns").setup()
    end}
    use{"kevinhwang91/nvim-hlslens", config = function()
        require("scrollbar.handlers.search").setup{}
    end}
    use{"petertriho/nvim-scrollbar", config = function()
        require("scrollbar").setup()
    end}

    use 'junegunn/fzf'
    use{'junegunn/fzf.vim', config = function()
        vim.keymap.set('n', '<C-p>', ':Files<CR>')
        vim.keymap.set('n', '<C-o>', ':BTags<CR>')
        vim.keymap.set('n', 'gd', ':Tags <C-R>=expand("<cword>")<CR><CR>')
        vim.keymap.set('n', 'gs', [[:call fzf#vim#ag(expand("<cword>"), '--literal --word-regexp', fzf#vim#with_preview())<CR>]])
        vim.keymap.set('v', 'gs', [[:call fzf#vim#ag('<C-R>"', '--literal', fzf#vim#with_preview())<CR>]])
        vim.keymap.set('n', 'go', [[:call fzf#vim#files('', fzf#vim#with_preview({'options': ['-q', '<C-R>"']}))<CR>]])
    end}

    use 'vim-syntastic/syntastic'
    use 'skywind3000/asyncrun.vim'

    use{'vim-airline/vim-airline', config = function()
        vim.g['airline#extensions#whitespace#checks'] = {'indent', 'mixed-indent-file', 'conflicts'}
    end}
    use{'vim-airline/vim-airline-themes', config = function()
        vim.g.airline_theme='luna'
    end}

    use{'mg979/vim-visual-multi', config = function()
        vim.g.VM_maps = {
            ['Find Under'] = '<C-d>',
            ['Find Subword Under'] = '<C-d>',
        }
    end}

    use{'skywind3000/vim-auto-popmenu', config = function()
        vim.g.apc_enable_ft = {c = 1, cpp = 1, lua = 1, python = 1}
        vim.opt.completeopt = "menu,menuone,noselect"
        vim.opt.shortmess:append('c')
    end}
end)

