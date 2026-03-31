local function python_payload(lines)
    return table.concat(lines, "\n") .. "\n"
end

require("plugins.repl").setup({
    keymap = "<C-e>",
    default_direction = "vertical",
    languages = {
        python = {
            filetypes = { "python" },
            cmd = "python3",
            build_payload = python_payload,
        },
        lua = {
            filetypes = { "lua" },
            cmd = "lua",
        },
        ruby = {
            filetypes = { "ruby" },
            cmd = "irb",
        },
        node = {
            filetypes = { "javascript" },
            cmd = "node",
        },
        sh = {
            filetypes = { "sh", "bash", "zsh" },
            cmd = "bash",
        },
    },
})
