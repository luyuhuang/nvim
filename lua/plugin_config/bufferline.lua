local bufferline = require('bufferline')

bufferline.setup{options = {
    mode = 'buffers',
    max_name_length = 30,
    offsets = {{
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        padding = 1,
    }},
}}

for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, function() bufferline.go_to_buffer(i, true) end)
end

vim.keymap.set('n', '<leader>j', '<Cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<leader>k', '<Cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', 'gT', '<Cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', 'gt', '<Cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', '<C-j>', '<Cmd>BufferLineMovePrev<CR>')
vim.keymap.set('n', '<C-k>', '<Cmd>BufferLineMoveNext<CR>')
vim.keymap.set('n', 'ZZ', '<Cmd>bdelete<CR>')
