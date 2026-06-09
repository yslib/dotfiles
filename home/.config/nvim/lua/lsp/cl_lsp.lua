return {
    cmd = { vim.fn.expand("~/.roswell/bin/cl-lsp") },
    filetypes = { 'lisp' },
    root_markers = {
        '*.asd',
        '.git',
    },
}
