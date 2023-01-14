local luasnip = require('luasnip')

local opts = {noremap = true, silent = true}
vim.keymap.set('s', '<Tab>', function() luasnip.jump(1) end, opts)
vim.keymap.set('s', '<S-Tab>', function() luasnip.jump(-1) end, opts)
vim.keymap.set('i', '<Tab>', function()
    return luasnip.expand_or_jumpable() and '<Plug>luasnip-expand-or-jump' or '<Tab>'
end, {silent = true, expr = true})
vim.keymap.set('i', '<S-Tab>', function() luasnip.jump(-1) end, opts)
