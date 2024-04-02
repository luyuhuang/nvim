local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local builtin = require('telescope.builtin')

configs.luahelper = { default_config = {
    cmd = {'luahelper-lsp', '-mode=1', '-logflag=0'},
    filetypes = {'lua'},
    root_dir = util.root_pattern('.git', 'luahelper.json'),
}}

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    focus = false,
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

require('lspconfig.ui.windows').default_options.border = 'rounded'

local function on_attach(client, bufnr)
    local bufopts = {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', '<C-o>', function() builtin.lsp_document_symbols{symbol_width = 0.8} end, bufopts)
    vim.keymap.set('n', 'gd', function() builtin.lsp_definitions{fname_width = 0.4} end, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gr', function() builtin.lsp_references{fname_width = 0.4} end, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)

    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {callback = vim.lsp.buf.document_highlight, buffer = bufnr})
    vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {callback = vim.lsp.buf.clear_references, buffer = bufnr})
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {callback = vim.lsp.buf.signature_help, buffer = bufnr})

    vim.api.nvim_buf_create_user_command(bufnr, 'Fmt', function(opts)
        local range
        if opts.range == 2 then
            range = {['start'] = {opts.line1, 0}, ['end'] = {opts.line2, 0}}
        end
        vim.lsp.buf.format{async = true, range = range}
    end, {range = true})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

if vim.fn.executable('luahelper-lsp') == 1 then
    lspconfig.luahelper.setup{on_attach = on_attach, capabilities = capabilities}
end

if vim.fn.executable('ccls') == 1 then
    lspconfig.ccls.setup{on_attach = on_attach, capabilities = capabilities, init_options = {
        index = {threads = 8},
    }}
elseif vim.fn.executable('clangd') == 1 then
    lspconfig.clangd.setup{on_attach = on_attach, capabilities = capabilities}
end

if vim.fn.executable('gopls') == 1 then
    lspconfig.gopls.setup{on_attach = on_attach, capabilities = capabilities}
end
