local utils = require('utils')
local tree = require('nvim-tree')
local view = require('nvim-tree.view')
local api = require('nvim-tree.api')

tree.setup{
    renderer = {indent_markers = {enable = true}},
    hijack_cursor = true,
    sync_root_with_cwd = true,
    view = {mappings = {list = {
        {key = 'gs', action = 'live grep', action_cb = function(node)
            require('telescope.builtin').live_grep(utils.live_grep_opts{search_dirs = {node.absolute_path}})
        end},
    }}}
}

vim.api.nvim_create_autocmd('BufEnter', {callback = function()
    if view.is_visible() then
        api.tree.find_file(vim.api.nvim_buf_get_name(0))
    end
end})
