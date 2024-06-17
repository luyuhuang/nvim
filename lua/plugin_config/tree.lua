local utils = require('utils')
local tree = require('nvim-tree')
local view = require('nvim-tree.view')
local api = require('nvim-tree.api')

local function on_attach(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', 'gs', function()
        local node = api.tree.get_node_under_cursor();
        require('telescope.builtin').live_grep(utils.live_grep_opts{search_dirs = {node.absolute_path}})
    end, {buffer = bufnr, silent = true});
end

tree.setup{
    renderer = {indent_markers = {enable = true}},
    hijack_cursor = true,
    sync_root_with_cwd = true,
    on_attach = on_attach,
    update_focused_file = {enable = true},
    view = {preserve_window_proportions = true}
}

