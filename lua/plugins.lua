return {
    {'lewis6991/gitsigns.nvim', config = function()
        local gs = require('gitsigns')
        gs.setup{
            current_line_blame = true,
            on_attach = function(bufnr)
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr=true})

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr=true})

                map('n', 'ghp', gs.preview_hunk)
                map('n', 'ghb', function() gs.blame_line{full=true} end)
                map('n', 'ghd', gs.diffthis)
                map('n', 'ghD', function() gs.diffthis('~') end)
                map('n', 'ghr', gs.reset_hunk)
            end,
        }
        require("scrollbar.handlers.gitsigns").setup()
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

    'junegunn/fzf',
    {'junegunn/fzf.vim', config = function()
        vim.keymap.set('n', '<C-p>', ':Files<CR>')
        vim.keymap.set('n', '<C-o>', ':BTags<CR>')
        vim.keymap.set('n', 'gd', ':Tags <C-R>=expand("<cword>")<CR><CR>')
        vim.keymap.set('n', 'gs', [[:call fzf#vim#ag(expand("<cword>"), '--literal --word-regexp', fzf#vim#with_preview())<CR>]])
        vim.keymap.set('v', 'gs', [[y :call fzf#vim#ag('<C-R>"', '--literal', fzf#vim#with_preview())<CR>]])
        vim.keymap.set('n', 'go', [[yi" :call fzf#vim#files('', fzf#vim#with_preview({'options': ['-q', '<C-R>"']}))<CR>]])
    end},

    'vim-syntastic/syntastic',
    'skywind3000/asyncrun.vim',
    'mg979/vim-visual-multi',

    {'skywind3000/vim-auto-popmenu', config = function()
        vim.g.apc_enable_ft = {c = 1, cpp = 1, lua = 1, python = 1}
        vim.opt.completeopt = "menu,menuone,noselect"
        vim.opt.shortmess:append('c')
    end},

    {'folke/tokyonight.nvim', config = function()
        vim.cmd('colorscheme tokyonight-day')
    end},
    {'nvim-lualine/lualine.nvim', config = function()
        require('lualine').setup{
            options = {
                icons_enabled = false,
                section_separators = '',
                component_separators = '',
            },
            sections = {lualine_c = {{'filename', path = 1}}},
        }
    end},
}
