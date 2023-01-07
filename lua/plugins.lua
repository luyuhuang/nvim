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

    {'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = {
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep',
    }, config = function()
        local builtin = require('telescope.builtin')
        local pickers = require('pickers')

        vim.keymap.set('n', '<leader>f', builtin.live_grep)
        vim.keymap.set('n', '<C-p>', builtin.find_files)
        vim.keymap.set('n', '<C-o>', pickers.current_buffer_tags)
        vim.keymap.set('n', 'gd', function()
            local cword = vim.fn.expand('<cword>')
            pickers.grep_tags({tag = cword, only_sort_tags = true})
        end)
        vim.keymap.set('n', 'gs', function()
            builtin.grep_string({word_match = '-w'})
        end)
        vim.keymap.set('v', 'gs', function()
            vim.cmd.normal('"fy')
            builtin.grep_string({search = vim.fn.getreg('"f')})
        end)
        vim.keymap.set('n', 'go', function()
            local cur = vim.fn.getline('.')
            local pos = vim.fn.getpos('.')[3]
            if cur:find('"', pos) then
                vim.cmd.normal('"fyi"')
            else
                vim.cmd.normal('"fyi\'')
            end
            builtin.find_files({default_text = vim.fn.getreg('"f')})
        end)

        vim.api.nvim_create_user_command('Glg', "Telescope git_commits", {})
        vim.api.nvim_create_user_command('Gst', "Telescope git_status", {})
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
            options = {
                icons_enabled = false,
                section_separators = '',
                component_separators = '',
            },
            sections = {lualine_c = {{'filename', path = 1}}},
        }
    end},
}
