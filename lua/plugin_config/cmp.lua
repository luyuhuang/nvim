local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup{
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
    }),
    sources = cmp.config.sources({
        {name = 'nvim_lsp'},
    }, {
        {name = 'tags'},
        {name = 'buffer'},
        {name = 'path'},
    })
}

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    focus = false,
})

vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {callback = function()
    vim.lsp.buf.signature_help()
end, pattern = "*"})
