require('blink.cmp').setup({
    keymap = { preset = 'default' },
    appearance = {
        nerd_font_variant = 'mono'
    },
    completion = {
        menu = {
            auto_show = true,
            max_height = 100,
        },
        documentation = { auto_show = false }
    },

    cmdline = {
        completion = {
            menu = {
                auto_show = true
            }
        }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = {
        implementation = "prefer_rust_with_warning"
    }
})
