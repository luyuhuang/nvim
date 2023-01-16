local telescope = require('telescope')
local sorters = require('telescope.sorters')
local builtin = require('telescope.builtin')
local make_entry = require('telescope.make_entry')
local finders = require('telescope.finders')
local Path = require('plenary.path')
local utils = require('utils')

local line_no
local function post()
    if line_no then
        vim.cmd.normal(line_no .. 'G')
        line_no = nil
    end
end

local function sorter(opts)
    opts = opts or {}
    local fzy = opts.fzy_mod or require('telescope.algos.fzy')
    local OFFSET = -fzy.get_score_floor()
    return sorters.Sorter:new({
        discard = true,
        scoring_function = function(_, prompt, line)
            local i = prompt:find(':', 1, true)
            if i then
                line_no = tonumber(prompt:sub(i + 1))
                prompt = prompt:sub(1, i - 1)
            else
                line_no = nil
            end
            if not fzy.has_match(prompt, line) then
                return -1
            end
            local fzy_score = fzy.score(prompt, line)
            if fzy_score == fzy.get_score_min() then
                return 1
            end
            return 1 / (fzy_score + OFFSET)
        end,
        highlighter = function(_, prompt, display)
            local i = prompt:find(':', 1, true)
            if i then
                prompt = prompt:sub(1, i - 1)
            end
            return fzy.positions(prompt, display)
        end
    })
end

local actions = require('telescope.actions')
actions.select_default._static_post.select_default = post
actions.select_horizontal._static_post.select_horizontal = post
actions.select_vertical._static_post.select_vertical = post
actions.select_tab._static_post.select_tab = post

telescope.setup{defaults = {
    file_sorter = sorter,
    layout_strategy = 'vertical',
}}

local function set_opts(opts)
    opts = opts or {}
    opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    opts.winnr = opts.winnr or vim.api.nvim_get_current_win()
    return opts
end

local function awk_tags(opts)
    opts = set_opts(opts)

    local tagfiles = opts.ctags_file and { opts.ctags_file } or vim.fn.tagfiles()
    for i, ctags_file in ipairs(tagfiles) do
        tagfiles[i] = vim.fn.expand(ctags_file, true)
    end
    if vim.tbl_isempty(tagfiles) then
        utils.log_err('No tags file found.')
        return
    end
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_ctags(opts)
    opts.finder = finders.new_oneshot_job(vim.tbl_flatten{'awk', opts.awk, tagfiles}, opts)

    return builtin.tags(opts)
end

local function current_buffer_tags(opts)
    opts = set_opts(opts)
    opts.prompt_title = 'Current Buffer Tags'
    opts.only_current_file = true
    opts.only_sort_tags = true
    opts.path_display = 'hidden'

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())
    local current_file = Path:new(vim.api.nvim_buf_get_name(opts.bufnr)):normalize(cwd)
    opts.awk = string.format('$2 == %q{print $0}', current_file)

    return awk_tags(opts)
end

local function grep_tags(opts)
    opts = set_opts(opts)
    opts.prompt_title = 'Grep Tags (' .. opts.tag .. ')'
    opts.awk = string.format('$1 == %q{print $0}', opts.tag)
    return awk_tags(opts)
end

vim.keymap.set('n', '<leader>f', builtin.live_grep)
vim.keymap.set('n', '<C-p>', builtin.find_files)
vim.keymap.set('n', '<C-o>', current_buffer_tags)
vim.keymap.set('n', 'gd', function()
    local cword = vim.fn.expand('<cword>')
    grep_tags({tag = cword})
end)
vim.keymap.set('n', 'gs', function()
    builtin.grep_string({word_match = '-w'})
end)
vim.keymap.set('v', 'gs', function()
    vim.cmd.normal('"fy')
    builtin.grep_string({search = vim.fn.getreg('"f')})
end)
vim.keymap.set('n', 'go', function()
    local cur = vim.fn.getline('.')
    local pos = vim.fn.getpos('.')[3]
    if cur:find('"', pos) then
        vim.cmd.normal('"fyi"')
    else
        vim.cmd.normal('"fyi\'')
    end
    builtin.find_files({default_text = vim.fn.getreg('"f')})
end)

vim.api.nvim_create_user_command('Glg', function() builtin.git_commits{initial_mode = 'normal'} end, {})
vim.api.nvim_create_user_command('Glgb', function() builtin.git_bcommits{initial_mode = 'normal'} end, {})
vim.api.nvim_create_user_command('Gst', function() builtin.git_status{initial_mode = 'normal'} end, {})
vim.api.nvim_create_user_command('Diag', function() builtin.diagnostics{initial_mode = 'normal'} end, {})
vim.api.nvim_create_user_command('Tags', function(opts)
    if opts.args and opts.args ~= '' then
        awk_tags({
            fname_width = 0.4,
            prompt_title = string.format('Tags ~ %q', opts.args),
            awk = string.format('$1 ~ %q{print $0}', opts.args)
        })
    else
        builtin.tags({fname_width = 0.4})
    end
end, {nargs = '?'})
