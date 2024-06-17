local utils = require('utils')

do -- tag preview
    local jump_stack = {}
    vim.keymap.set('n', 'K', function()
        local cword = vim.fn.expand('<cword>')
        local win = vim.api.nvim_open_win(0, true, {
            border = 'single', style = 'minimal', relative = 'cursor',
            row = 1, col = 1, height = math.floor(vim.o.lines * 0.3), width = math.floor(vim.o.columns * 0.7)
        })
        if pcall(vim.cmd.tag, cword) then
            table.insert(jump_stack, win)
        else
            vim.api.nvim_win_close(win, false)
            utils.log_warn('tag %q not found', cword)
        end
    end, {noremap = true})

    vim.keymap.set('n', '<Esc>', function()
        local win = table.remove(jump_stack)
        while win and not vim.api.nvim_win_is_valid(win) do
            win = table.remove(jump_stack)
        end
        if win then
            vim.api.nvim_win_close(win, false)
        end
    end)
end

do -- auto tags
    vim.loop.disable_stdio_inheritance()
    local running
    vim.api.nvim_create_autocmd('BufWritePost', {callback = function()
        if running then return end
        local ctags_opts = vim.g.ctags_opts or '-R'
        local ctags = 'ctags -o .tmptags ' .. ctags_opts
        vim.loop.new_work(function(ctags)
            if not vim.loop.fs_access('.tmptags', 0) and vim.loop.fs_access('tags', 0) then
                return os.execute(ctags) == 0 and vim.loop.fs_rename('.tmptags', 'tags')
            end
        end, function()
            running = false
        end):queue(ctags)
        running = true
    end})
    vim.api.nvim_create_autocmd('VimLeave', {callback = function()
        vim.loop.fs_unlink('.tmptags')
    end})
end

do -- goto last position
    vim.api.nvim_create_autocmd('BufReadPost', {callback = function()
        local line = vim.fn.line('\'"')
        if line > 1 and line <= vim.fn.line('$') then
            vim.cmd.normal('g`"')
        end
    end})
end

do
    vim.api.nvim_create_autocmd({'BufEnter', 'FocusGained'}, {command = 'checktime'})
end

if vim.env.TMUX then
    vim.g.clipboard = {
        name = 'tmux-clipboard',
        copy = {
            ['+'] = {'tmux', 'load-buffer', '-w', '-'},
        },
        paste = {
            ['+'] = {'tmux', 'save-buffer', '-'},
        },
        cache_enabled = true,
    }
end

do
    local function cmt(c)
        return function() vim.bo.commentstring = c end
    end
    vim.api.nvim_create_autocmd('FileType', {pattern = {'cpp', 'c'}, callback = cmt('// %s')})
end

do
    local function home()
        local head = (vim.api.nvim_get_current_line():find('[^%s]') or 1) - 1
        local cursor = vim.api.nvim_win_get_cursor(0)
        cursor[2] = cursor[2] == head and 0 or head
        vim.api.nvim_win_set_cursor(0, cursor)
    end

    vim.keymap.set({'i', 'n'}, '<Home>', home)
    vim.keymap.set('n', '0', home)
end

do
    vim.opt.sessionoptions = 'buffers,curdir,tabpages,winsize'
    local path = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')

    vim.api.nvim_create_autocmd('VimLeavePre', {callback = function()
        vim.fn.mkdir(path, 'p')
        vim.cmd('mks! ' .. path .. vim.fn.sha256(vim.fn.getcwd()) .. '.vim')
    end})

    vim.api.nvim_create_user_command('Resume', function()
        local fname = path .. vim.fn.sha256(vim.fn.getcwd()) .. '.vim'
        if vim.fn.filereadable(fname) ~= 0 then
            vim.cmd.source(fname)
            vim.cmd('Lazy load bufferline.nvim')
        end
    end, {})
end
