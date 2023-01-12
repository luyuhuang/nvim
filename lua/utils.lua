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

return utils
