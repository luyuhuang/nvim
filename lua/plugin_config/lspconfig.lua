local builtin = require('telescope.builtin')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local function signature_help()
    return vim.lsp.buf.signature_help{
        silent = true,
        border = "rounded",
        focus = false,
        focusable = false,
    }
end

local function hover()
    return vim.lsp.buf.hover{
        border = "rounded",
    }
end

vim.api.nvim_create_autocmd('LspAttach', {callback = function(args)
    local bufnr = args.buf
    local bufopts = {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', '<C-o>', function() builtin.lsp_document_symbols{symbol_width = 0.8} end, bufopts)
    vim.keymap.set('n', 'gd', function() builtin.lsp_definitions{fname_width = 0.4} end, bufopts)
    vim.keymap.set('n', 'K', hover, bufopts)
    vim.keymap.set('n', 'grr', function() builtin.lsp_references{fname_width = 0.4} end, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)

    local capabilities = vim.lsp.get_clients{id = args.data.client_id}[1].server_capabilities
    if capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {callback = vim.lsp.buf.document_highlight, buffer = bufnr})
    end
    vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {callback = vim.lsp.buf.clear_references, buffer = bufnr})
    if capabilities.signatureHelpProvider then
        vim.api.nvim_create_autocmd({'CursorHoldI'}, {callback = signature_help, buffer = bufnr})
    end

    vim.api.nvim_buf_create_user_command(bufnr, 'Fmt', function(opts)
        local range
        if opts.range == 2 then
            range = {['start'] = {opts.line1, 0}, ['end'] = {opts.line2, 0}}
        end
        vim.lsp.buf.format{async = true, range = range}
    end, {range = true})
end})

vim.lsp.config('*', {capabilities = cmp_nvim_lsp.default_capabilities()})

if vim.fn.executable('luahelper-lsp') == 1 then
    vim.lsp.config('luahelper', {
        cmd = {'luahelper-lsp', '-mode=1', '-logflag=0'},
        filetypes = {'lua'},
        root_markers = {'.git', 'luahelper.json'},
    })
    vim.lsp.enable('luahelper')
end

if vim.fn.executable('ccls') == 1 then
    vim.lsp.config('ccls', {init_options = {
        index = {threads = 8},
    }})
    vim.lsp.enable('ccls')
elseif vim.fn.executable('clangd') == 1 then
    vim.lsp.enable('clangd')
end

if vim.fn.executable('gopls') == 1 then
    vim.lsp.enable('gopls')
end
