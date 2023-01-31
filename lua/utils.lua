local utils = {}

function utils.log_info(fmt, ...)
    vim.notify(fmt:format(...), vim.log.levels.INFO)
end

function utils.log_warn(fmt, ...)
    vim.notify(fmt:format(...), vim.log.levels.WARN)
end

function utils.log_err(fmt, ...)
    vim.notify(fmt:format(...), vim.log.levels.ERROR)
end

function utils.live_grep_opts(opts)
    local flags = tostring(vim.v.count)
    local additional_args = {}
    local prompt_title = 'Live Grep'
    if flags:find('1') then
        prompt_title = prompt_title .. ' [.*]'
    else
        table.insert(additional_args, '--fixed-strings')
    end
    if flags:find('2') then
        prompt_title = prompt_title .. ' [w]'
        table.insert(additional_args, '--word-regexp')
    end
    if flags:find('3') then
        prompt_title = prompt_title .. ' [Aa]'
        table.insert(additional_args, '--case-sensitive')
    end

    opts = opts or {}
    opts.additional_args = function() return additional_args end
    opts.prompt_title = prompt_title
    return opts
end

return utils
