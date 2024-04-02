local bufferline = require('bufferline')
local utils = require('utils')

local hide = {
    qf = true,
}

bufferline.setup{options = {
    mode = 'buffers',
    max_name_length = 30,
    sort_by = 'none',
    offsets = {{
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        padding = 1,
    }},
    custom_filter = function(bufnr)
        return not hide[vim.bo[bufnr].filetype]
    end
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
vim.keymap.set('n', 'ZZ', function()
    if vim.bo.modified then
        vim.cmd.write()
    end
    vim.cmd.bdelete()
end)


vim.api.nvim_create_user_command('CL', 'BufferLineCloseLeft', {})
vim.api.nvim_create_user_command('CR', 'BufferLineCloseRight', {})
