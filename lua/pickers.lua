local make_entry = require('telescope.make_entry')
local finders = require('telescope.finders')
local Path = require('plenary.path')
local builtin = require('telescope.builtin')

local M = {}

local function set_opts(opts)
    opts = opts or {}
    opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    opts.winnr = opts.winnr or vim.api.nvim_get_current_win()
    return opts
end

function M.awk_tags(opts)
    opts = set_opts(opts)

    local tagfiles = opts.ctags_file and { opts.ctags_file } or vim.fn.tagfiles()
    for i, ctags_file in ipairs(tagfiles) do
        tagfiles[i] = vim.fn.expand(ctags_file, true)
    end
    if vim.tbl_isempty(tagfiles) then
        print('No tags file found.')
        return
    end
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_ctags(opts)
    opts.finder = finders.new_oneshot_job(vim.tbl_flatten{'awk', opts.awk, tagfiles}, opts)

    return builtin.tags(opts)
end

function M.current_buffer_tags(opts)
    opts = set_opts(opts)
    opts.prompt_title = 'Current Buffer Tags'
    opts.only_current_file = true
    opts.path_display = 'hidden'

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())
    local current_file = Path:new(vim.api.nvim_buf_get_name(opts.bufnr)):normalize(cwd)
    opts.awk = string.format('$2 == %q{print $0}', current_file)

    return M.awk_tags(opts)
end

function M.grep_tags(opts)
    opts = set_opts(opts)
    opts.prompt_title = 'Grep Tags (' .. opts.tag .. ')'
    opts.awk = string.format('$1 == %q{print $0}', opts.tag)
    return M.awk_tags(opts)
end

return M
