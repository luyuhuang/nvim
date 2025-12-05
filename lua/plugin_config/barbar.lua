local barbar = require('barbar')
local utils = require('utils')

barbar.setup{
    exclude_ft = {'qf'},
    icons = {
        separator_at_end = false,
    },
    sidebar_filetypes = {
        NvimTree = {event = 'BufWinLeave', text = 'File Explorer', align = 'center'},
    },
}

for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, function() vim.cmd.BufferGoto(i) end)
end

vim.keymap.set('n', '<leader>j', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<leader>k', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', 'gT', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', 'gt', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<C-j>', '<Cmd>BufferMovePrevious<CR>')
vim.keymap.set('n', '<C-k>', '<Cmd>BufferMoveNext<CR>')
vim.keymap.set('n', '<M-,>', '<Cmd>BufferScrollLeft 10<CR>')
vim.keymap.set('n', '<M-.>', '<Cmd>BufferScrollRight 10<CR>')

vim.keymap.set('n', 'ZZ', function()
    if vim.bo.modified then
        vim.cmd.write()
    end
    vim.cmd.BufferClose()
end)

vim.keymap.set('n', '<leader>c', function()
    vim.cmd.BufferClose()
end)

vim.keymap.set('n', '<leader>r', function()
    vim.cmd.BufferRestore()
end)

vim.api.nvim_create_user_command('CL', 'BufferCloseBuffersLeft', {})
vim.api.nvim_create_user_command('CR', 'BufferCloseBuffersRight', {})
