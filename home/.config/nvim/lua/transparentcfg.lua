require("transparent").setup({
    groups = { -- table: default groups
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLineNr', 'EndOfBuffer',
    },
    extra_groups = {},   -- table: additional groups that should be cleared
    exclude_groups = {}, -- table: groups you don't want to clear
})

require('transparent').clear_prefix('BufferLine')

-- require('transparent').clear_prefix('lualine')
