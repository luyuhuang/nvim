vim.opt.number = true
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.lazyredraw = true
vim.opt.autoread = true
vim.opt.scrolloff = 3
vim.opt.backspace = 'indent,eol,start'
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10
vim.opt.mouse=''
vim.opt.termguicolors = true

vim.opt.foldenable = true
vim.opt.fdm = 'indent'
vim.opt.foldlevel = 99

vim.opt.wrap = false
vim.keymap.set('n', 'L', '10zl')
vim.keymap.set('n', 'H', '10zh')
vim.keymap.set('n', '<M-z>', function()
    vim.opt.wrap = not vim.opt.wrap:get()
end)

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set('n', '<C-h>', '<C-o>', {noremap = true})
vim.keymap.set('n', '<C-l>', '<C-i>', {noremap = true})
vim.keymap.set('n', '<C-j>', ':tabm -1<CR>', {silent = true})
vim.keymap.set('n', '<C-k>', ':tabm +1<CR>', {silent = true})

vim.keymap.set('n', 'y/', '/<C-R>"<CR>')
vim.keymap.set('v', '/', 'y :/<C-R>"<CR>', {noremap = true})
vim.keymap.set('v', '?', 'y :?<C-R>"<CR>', {noremap = true})

local jump_stack = {}
vim.keymap.set('n', '<C-]>', function()
    local cword = vim.fn.expand('<cword>')
    local win = vim.api.nvim_open_win(vim.fn.bufnr(), true, {
        border = 'single', style = 'minimal', relative = 'cursor',
        row = 1, col = 1, height = math.floor(vim.o.lines * 0.3), width = math.floor(vim.o.columns * 0.7)
    })
    if pcall(vim.cmd.tag, cword) then
        table.insert(jump_stack, win)
    else
        vim.api.nvim_win_close(win, false)
        print("tag `" .. cword .. "' not found")
    end
end, {noremap = true})
vim.keymap.set('n', '<Esc>', function()
    local win = table.remove(jump_stack)
    while win and not vim.api.nvim_win_is_valid(win) do
        win = table.remove(jump_stack)
    end
    if win then
        vim.api.nvim_win_close(win, false)
    end
end)

vim.keymap.set('i', '<C-h>', '<left>')
vim.keymap.set('i', '<C-j>', '<down>')
vim.keymap.set('i', '<C-k>', '<up>')
vim.keymap.set('i', '<C-l>', '<right>')

vim.g.mapleader = ' '
for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, i .. 'gt')
end

vim.keymap.set('n', '<leader>t', '<C-W>T')
vim.keymap.set('n', '<leader>o', '<C-W>o')
vim.keymap.set('n', '<leader>l', ':nohl<CR>', {silent = true})

vim.api.nvim_create_autocmd('BufWritePost', {callback = function()
    if vim.g.asyncrun_status ~= 'running' then
        vim.cmd.AsyncRun('[ ! -e .tmptags ] && [ -e tags ] && ctags -R -o .tmptags && mv .tmptags tags')
    end
end})
vim.api.nvim_create_autocmd('VimLeave', {command = '!rm -f .tmptags'})

vim.api.nvim_create_autocmd('BufReadPost', {callback = function()
    local line = vim.fn.line('\'"')
    if line > 1 and line <= vim.fn.line('$') then
        vim.cmd.normal('g`"')
    end
end})

