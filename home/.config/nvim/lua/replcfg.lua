local function python_payload(lines)
    return table.concat(lines, "\n") .. "\n"
end

local function python_send(term, payload, ctx)
    -- Use bracketed paste mode to preserve indentation
    vim.api.nvim_chan_send(term.job_id, "\27[200~" .. payload .. "\27[201~")
    vim.defer_fn(function()
        vim.api.nvim_chan_send(term.job_id, "\n")
    end, 100)
end

require("plugins.repl").setup({
    keymap = "<C-e>",
    default_direction = "vertical",
    languages = {
        python = {
            filetypes = { "python" },
            cmd = "python3",
            build_payload = python_payload,
            send = python_send,
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
