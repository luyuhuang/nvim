local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local builtin = require('telescope.builtin')

configs.luahelper = { default_config = {
    cmd = {'luahelper-lsp', '-mode=1', '-logflag=0'},
    filetypes = {'lua'},
    root_dir = util.root_pattern('.git', 'luahelper.json'),
}}

local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', '<C-o>', builtin.lsp_document_symbols, bufopts)
    vim.keymap.set('n', 'gd', function() builtin.lsp_definitions{jump_type = 'never'} end, bufopts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.luahelper.setup{on_attach = on_attach, capabilities = capabilities}
lspconfig.clangd.setup{on_attach = on_attach, capabilities = capabilities}
