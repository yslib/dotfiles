---@type opencode.Opts
vim.g.opencode_opts = {
    provider = {
        enabled = "tmux"
    }
}
-- Required for `opts.events.reload`.
vim.o.autoread = true

-- Recommended/example keymaps.
-- vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end,
--     { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<leader>as", function() require("opencode").select() end,
    { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<leader>at", function() require("opencode").toggle() end, { desc = "Toggle opencode" })


vim.api.nvim_create_autocmd("User", {
    pattern = "OpencodeEvent:*",
    callback = function(args)
        ---@type opencode.cli.client.Event
        local event = args.data.event
        ---@type number
        local port = args.data.port

        -- vim.notify(vim.inspect(event))
        if event.type == "session.idle" then
            vim.notify("`opencode` finished responding")
        end
    end,
})
