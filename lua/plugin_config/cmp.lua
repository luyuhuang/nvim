local cmp = require('cmp')
local luasnip = require('luasnip')

vim.opt.completeopt = 'menu,menuone,noselect'

cmp.setup{
    completion = {keyword_length = 1},
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
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

cmp.setup.cmdline({ '/', '?' }, {
    completion = {keyword_length = 3},
    window = {completion = cmp.config.window.bordered()},
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        {name = 'buffer'}
    }
})

cmp.setup.cmdline(':', {
    completion = {keyword_length = 2},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        {name = 'path'}
    }, {
        {name = 'cmdline'}
    })
})
