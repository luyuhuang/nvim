local gs = require('gitsigns')
gs.setup{
    current_line_blame = true,
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        map('n', 'ghp', gs.preview_hunk)
        map('n', 'ghb', function() gs.blame_line{full=true} end)
        map('n', 'ghd', gs.diffthis)
        map('n', 'ghD', function() gs.diffthis('~') end)
        map('n', 'ghr', gs.reset_hunk)
    end,
}

require("scrollbar.handlers.gitsigns").setup()
