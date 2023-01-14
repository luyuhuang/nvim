local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

configs.luahelper = { default_config = {
    cmd = {'luahelper-lsp', '-mode=1', '-logflag=0'},
    filetypes = {'lua'},
    root_dir = util.root_pattern('.git', 'luahelper.json'),
}}

local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
end

require('lspconfig').luahelper.setup{on_attach = on_attach}
