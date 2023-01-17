local cmp = require('cmp')
local luasnip = require('luasnip')

vim.opt.completeopt = 'menu,menuone,noselect'

cmp.setup{
    completion = {keyword_length = 3},
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<down>'] = cmp.mapping.select_next_item(),
        ['<up>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm(),
    }),
    sources = cmp.config.sources({
        {name = 'nvim_lsp'},
    }, {
        {name = 'tags'},
        {name = 'buffer'},
        {name = 'path'},
    })
}

