require('lualine').setup{
    options = {
        globalstatus = true,
        component_separators = '',
        section_separators = { left = '', right = '' }
    },
    sections = {lualine_c = {{'filename', path = 1}}},
    sections = {
        lualine_a = {
            {'mode', separator = { left = '', right =''}}
        },
        lualine_c = {
            {'filename', path = 1}
        },
        lualine_x = {'encoding', 'fileformat'},
        lualine_y = {'filetype', 'progress'},
        lualine_z = {
            {'location', separator = {left = '', right =''}},
        },
    },
}
