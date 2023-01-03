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

vim.opt.foldenable = true
vim.opt.fdm = 'indent'
vim.opt.foldlevel = 99

vim.wo.wrap = false
vim.keymap.set('n', 'L', '10zl')
vim.keymap.set('n', 'H', '10zh')

vim.cmd[[
filetype on
filetype plugin on
filetype indent on

set tabstop=4
set softtabstop=4
set shiftwidth=4

nnoremap <C-h> <C-o>
nnoremap <C-l> <C-i>
nmap <C-j> :tabm -1<CR>
nmap <C-k> :tabm +1<CR>
nmap <C-n> :nohl <CR>
]]

vim.g.mapleader = "<space>"
for i = 1, 9 do
    vim.keymap.set('n', tostring(i), i .. 'gt')
end

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

