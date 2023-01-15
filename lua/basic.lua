local utils = require('utils')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
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
vim.opt.updatetime = 300

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

local function search_reg(dir, reg)
    local origin = vim.fn.getreg(reg or '"')
    local pattern = origin:gsub('[/\\]', {['/'] = '\\/', ['\\'] = '\\\\'})
    if not pcall(vim.cmd, dir .. '\\V' .. pattern) then
        utils.log_warn('pattern %q not found', origin)
    end
end

vim.keymap.set('n', 'y/', function() search_reg('/', vim.v.register) end)
vim.keymap.set('n', 'y?', function() search_reg('?', vim.v.register) end)
vim.keymap.set('v', '/', function() vim.cmd.normal('y') search_reg('/') end)
vim.keymap.set('v', '?', function() vim.cmd.normal('y') search_reg('?') end)

vim.keymap.set('i', '<C-h>', '<left>')
vim.keymap.set('i', '<C-j>', '<down>')
vim.keymap.set('i', '<C-k>', '<up>')
vim.keymap.set('i', '<C-l>', '<right>')

vim.keymap.set('i', '<C-v>', function()
    return vim.fn.col('.') == 1 and '<Esc>"cPa' or '<Esc>"cpa'
end, {expr = true})
vim.keymap.set('v', '<C-v>', '"cp')
vim.keymap.set('v', '<C-c>', '"cy')

vim.g.mapleader = ' '
for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, i .. 'gt')
end
vim.keymap.set('n', '<leader>j', 'gT')
vim.keymap.set('n', '<leader>k', 'gt')

vim.keymap.set('n', '<leader>t', '<C-W>T')
vim.keymap.set('n', '<leader>o', '<C-W>o')
vim.keymap.set('n', '<leader>l', ':nohl<CR>', {silent = true})

