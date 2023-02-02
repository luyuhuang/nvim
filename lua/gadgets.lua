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

do -- exrc
    vim.opt.exrc = false
    local function exrc()
        if vim.fn.empty(vim.fn.glob('~/.nvimrc.lua')) ~= 1 then
            vim.cmd.source('~/.nvimrc.lua')
        end
        if vim.fn.empty(vim.fn.glob('.exrc.lua')) ~= 1 then
            vim.cmd.source('.exrc.lua')
        end
    end

    if vim.v.vim_did_enter == 1 then
        exrc()
    else
        vim.api.nvim_create_autocmd('VimEnter', {callback = exrc})
    end
end

do
    vim.api.nvim_create_autocmd('BufEnter', {callback = function()
        if vim.fn.winnr('$') == 1 and vim.bo.filetype == 'NvimTree' then
            vim.cmd.quit()
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
