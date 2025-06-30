local utils = require('utils')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
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
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50
vim.opt.mouse = ''
vim.opt.termguicolors = true
vim.opt.updatetime = 300
vim.opt.showmode = false
vim.opt.fileencodings = 'ucs-bom,utf-8,default,gbk,latin1'
vim.opt.exrc = true

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
vim.api.nvim_create_autocmd('FileType', {pattern = {'scheme', 'lisp', 'racket', 'yaml'}, callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
end})

vim.keymap.set('n', '<C-h>', '<C-o>', {noremap = true})
vim.keymap.set('n', '<C-l>', '<C-i>', {noremap = true})

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

vim.keymap.set({'i', 'c'}, '<C-v>', '<C-r>+')
vim.keymap.set('v', '<C-v>', '"+p')
vim.keymap.set('t', '<C-v>', '<C-\\><C-n>"+pa')
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-c>', '"+yiw')

vim.keymap.set({'n', 'i'}, '<C-s>', '<Cmd>w<CR>')

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>o', '<C-W>o')
vim.keymap.set('n', '<leader>l', '<Cmd>nohl<CR>')

vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')
