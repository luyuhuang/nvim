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

local function uri_exists(uri)
    for _, win in ipairs(vim.fn.getwininfo()) do
        if vim.lsp.util.make_text_document_params(win.bufnr).uri == uri then
            return true
        end
    end
    return false
end

vim.lsp.handlers['textDocument/definition'] = function(_, result, ctx, config)
    if vim.tbl_islist(result) then result = result[1] end
    if not result then return end
    if result.uri ~= ctx.params.textDocument.uri and not uri_exists(result.uri) then
        vim.cmd.tabedit()
    end
    local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
    vim.lsp.util.jump_to_location(result, offset_encoding, true)
end

require('lspconfig.ui.windows').default_options.border = 'rounded'

local function on_attach(client, bufnr)
    local bufopts = {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', '<C-o>', function() builtin.lsp_document_symbols{symbol_width = 0.8} end, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'g]', function() builtin.lsp_definitions{jump_type = 'never'} end, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
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

if vim.fn.executable('clangd') == 1 then
    lspconfig.clangd.setup{on_attach = on_attach, capabilities = capabilities}
end

if vim.fn.executable('gopls') == 1 then
    lspconfig.gopls.setup{on_attach = on_attach, capabilities = capabilities}
end
