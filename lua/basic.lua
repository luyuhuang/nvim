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
vim.opt.updatetime = 100
vim.opt.backspace = 'indent,eol,start'
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10
vim.opt.mouse=''
vim.opt.termguicolors = true

vim.opt.foldenable = true
vim.opt.fdm = 'indent'
vim.opt.foldlevel = 99

vim.wo.wrap = false
vim.keymap.set('n', 'L', '10zl')
vim.keymap.set('n', 'H', '10zh')

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set('n', '<C-h>', '<C-o>', {noremap = true})
vim.keymap.set('n', '<C-l>', '<C-i>', {noremap = true})
vim.keymap.set('n', '<C-j>', ':tabm -1<CR>')
vim.keymap.set('n', '<C-k>', ':tabm +1<CR>')
vim.keymap.set('n', '<C-n>', ':nohl<CR>')

vim.keymap.set('n', 'y/', '/<C-R>"<CR>')
vim.keymap.set('v', '/', 'y :/<C-R>"<CR>', {noremap = true})
vim.keymap.set('v', '?', 'y :?<C-R>"<CR>', {noremap = true})
vim.keymap.set('n', '<C-]>', '<C-w><C-]><C-w>L', {noremap = true})

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

vim.cmd[[
autocmd BufWritePost *
    \ if g:asyncrun_status != 'running' |
    \     exec "AsyncRun [ ! -e .tmptags ] && [ -e tags ] && ctags -R -o .tmptags && mv .tmptags tags" |
    \ endif

autocmd VimLeave * :! rm -f .tmptags

autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \    exe "normal! g`\"" |
    \ endif
]]

