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
            print("tag `" .. cword .. "' not found")
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
    vim.api.nvim_create_autocmd('BufWritePost', {callback = function()
        local ctags_opts = vim.g.ctags_opts or '-R'
        local ctags = 'ctags -o .tmptags ' .. ctags_opts
        if vim.g.asyncrun_status ~= 'running' then
            vim.cmd.AsyncRun('[ ! -e .tmptags ] && [ -e tags ] && ' .. ctags .. ' && mv .tmptags tags')
        end
    end})
    vim.api.nvim_create_autocmd('VimLeave', {command = '!rm -f .tmptags'})
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
